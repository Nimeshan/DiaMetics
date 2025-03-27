import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openfood;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'HamburgerMenu.dart';
import 'Barcode.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

class SugarIntake extends StatefulWidget {
  const SugarIntake({super.key});

  @override
  State<SugarIntake> createState() => _SugarIntakeState();
}

// Controller for Search Input and the Lists for User's selected food items and the Food Search Result
class _SugarIntakeState extends State<SugarIntake> {
  final TextEditingController _searchController = TextEditingController();
  final List<openfood.Product> _selectedFoods = [];
  List<openfood.Product> _searchResults = [];

  final auth.User _user = auth.FirebaseAuth.instance.currentUser!;

// Configuration of the Open Food Facts API
  @override
  void initState() {
    super.initState();
    openfood.OpenFoodAPIConfiguration.userAgent = openfood.UserAgent(
      name: 'SugarIntakeApp',
      version: '1.0',
    );
    openfood.OpenFoodAPIConfiguration.globalLanguages = [
      openfood.OpenFoodFactsLanguage.ENGLISH
    ];
    openfood.OpenFoodAPIConfiguration.globalCountry =
        openfood.OpenFoodFactsCountry.USA;

    _loadSelectedFoods();
  }

  // Load selected foods from local storage
  Future<void> _loadSelectedFoods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('selected_foods');

    List<dynamic> decodedData = storedData != null && storedData.isNotEmpty
        ? json.decode(storedData)
        : [];

    setState(() {
      _selectedFoods.addAll(
        decodedData.map((item) => openfood.Product.fromJson(item)).toList(),
      );
    });
  }

// Save selected foods to local storage
  Future<void> _saveSelectedFoods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = json.encode(
      _selectedFoods.map((product) => product.toJson()).toList(),
    );
    await prefs.setString('selected_foods', jsonData);
  }

// Extract sugar content from product data
  String _getSugarContent(openfood.Product product) {
    double? sugarContent = product.nutriments?.getValue(
      openfood.Nutrient.sugars,
      openfood.PerSize.oneHundredGrams,
    );
    return sugarContent != null ? '${sugarContent.toStringAsFixed(1)}g' : 'N/A';
  }

// Search for food in OpenFoodFacts database
  Future<void> _searchFood(String query) async {
    if (query.isEmpty) return;

    try {
      final config = openfood.ProductSearchQueryConfiguration(
        parametersList: [
          openfood.SearchTerms(terms: [query]),
        ],
        language: openfood.OpenFoodFactsLanguage.ENGLISH,
        country: openfood.OpenFoodFactsCountry.USA,
        fields: [
          openfood.ProductField.NAME,
          openfood.ProductField.IMAGE_FRONT_URL,
          openfood.ProductField.NUTRIMENTS,
        ],
        version: openfood.ProductQueryVersion.v3,
      );

      final result = await openfood.OpenFoodAPIClient.searchProducts(
        null,
        config,
      );

      if (result.products != null && result.products!.isNotEmpty) {
        setState(() {
          _searchResults = result.products!;
        });
      } else {
        debugPrint("No products found.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No products found.")),
        );
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

// Add food to selected list and saves both on Firebase and local storage
  void _addFood(openfood.Product product) async {
    setState(() {
      _selectedFoods.add(product);
      _searchResults.clear();
      _searchController.clear();
    });

    await _saveSelectedFoods();
    await _storeFoodInFirebase(product);
  }

// Store food in Firebase
  Future<void> _storeFoodInFirebase(openfood.Product product) async {
    try {
      String foodName = product.productName ?? "Unknown Food";
      double sugarContent = product.nutriments?.getValue(
              openfood.Nutrient.sugars, openfood.PerSize.oneHundredGrams) ??
          0;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('sugarIntake')
          .add({
        'foodName': foodName,
        'sugarContent': sugarContent,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Food added to Firebase successfully.");
    } catch (e) {
      print("Error storing food in Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2893E),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, size: 20),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HospitalLocator()),
              );
            },
            icon: const Icon(Icons.local_hospital, size: 20),
          ),
        ],
      ),
      drawer: const HamburgerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Add Sugar Intake",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              // Search Field used to Search Food
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  hintText: 'Search for food...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchResults.clear());
                    },
                  ),
                ),
                onSubmitted: _searchFood,
              ),
            ),
            // Scan Barcode Button
            ElevatedButton(
              onPressed: () async {
                final scannedProduct = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Barcode()),
                );

                if (scannedProduct != null) {
                  _addFood(scannedProduct);
                }
              },
              child: const Text("Scan Barcode"),
            ),
            // Search results from the Above Search
            if (_searchResults.isNotEmpty)
              Column(
                children: _searchResults.map((product) {
                  return ListTile(
                    leading: product.imageFrontUrl != null
                        ? Image.network(product.imageFrontUrl!,
                            width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.fastfood, size: 50),
                    title: Text(product.productName ?? "Unknown Food"),
                    subtitle: Text("Sugar: ${_getSugarContent(product)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () => _addFood(product),
                    ),
                  );
                }).toList(),
              ),
            // Section to show the Food You have eaten
            const SizedBox(height: 20),
            if (_selectedFoods.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What you have eaten:",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._selectedFoods.map((product) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: product.imageFrontUrl != null
                            ? Image.network(
                                product.imageFrontUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.fastfood, size: 50),
                        title: Text(product.productName ?? "Unknown Food"),
                        subtitle: Text("Sugar: ${_getSugarContent(product)}"),
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
