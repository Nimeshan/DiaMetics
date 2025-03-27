import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openfood;
import 'HamburgerMenu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:diametics/Screens/HospitalLocator.dart';
import 'package:diametics/Screens/DiabeticLevel.dart';
import 'package:diametics/Screens/SugarIntake.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

// Variable and Lists that Store Diabetic Level, History Data and stores food product details
class _HomePageState extends State<HomePage> {
  int diabeticLevel = 0;
  List<int> sugarLevels = [];
  List<openfood.Product> _selectedFoods = [];

// Loads saved diabetic, sugar levels, and saved food items
  @override
  void initState() {
    super.initState();
    _loadDiabeticLevel();
    _loadSugarLevels();
    _loadSelectedFoods();
  }

// Load diabetic level from local storage
  Future<void> _loadDiabeticLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      diabeticLevel = prefs.getInt('diabeticLevel') ?? 0;
    });
  }

// Load sugar levels from local storage
  Future<void> _loadSugarLevels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('sugar_levels');
    if (storedData != null) {
      setState(() {
        sugarLevels = List<int>.from(json.decode(storedData));
      });
    }
  }

// Load selected foods from local storage
  Future<void> _loadSelectedFoods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('selected_foods');
    if (storedData != null) {
      setState(() {
        _selectedFoods = (json.decode(storedData) as List)
            .map((item) => openfood.Product.fromJson(item))
            .toList();
      });
    }
  }

// Categorize risk level based on sugar reading
  String getRiskLevel(int level) {
    if (level < 70) {
      return "Low";
    } else if (level >= 70 && level <= 100) {
      return "Normal";
    } else if (level >= 101 && level <= 125) {
      return "Medium";
    } else {
      return "High";
    }
  }

// Get color based on risk level
  Color getRiskColor(int level) {
    if (level < 70) {
      return Colors.blue;
    } else if (level >= 70 && level <= 100) {
      return Colors.green;
    } else if (level >= 101 && level <= 125) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

// Extract sugar content from product data
  String _getSugarContent(openfood.Product product) {
    double? sugarContent = product.nutriments?.getValue(
      openfood.Nutrient.sugars,
      openfood.PerSize.oneHundredGrams,
    );
    return sugarContent != null
        ? '${sugarContent.toStringAsFixed(1)}g sugar'
        : 'N/A';
  }

// Generate pie chart data from sugar levels
  List<PieChartSectionData> _getPieChartData() {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    return sugarLevels.asMap().entries.map((entry) {
      final int index = entry.key;
      final int value = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: value.toDouble(),
        radius: 35,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2893E),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, size: 20),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        // Refresh button to referesh the Piechart ajnd the food list.
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _loadSugarLevels();
              await _loadSelectedFoods();
              setState(() {});
            },
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Sugar level chart section
            AspectRatio(
              aspectRatio: 1.38,
              child: sugarLevels.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiabeticLevel()),
                        );
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monitor_heart_outlined,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No Diabetic Levels Added Yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap to add your levels",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sections: _getPieChartData(),
                            centerSpaceRadius: 80,
                            sectionsSpace: 2,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getRiskLevel(
                                  sugarLevels.isNotEmpty ? sugarLevels[0] : 0),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: getRiskColor(sugarLevels.isNotEmpty
                                    ? sugarLevels[0]
                                    : 0),
                              ),
                            ),
                            Text(
                              sugarLevels.isNotEmpty
                                  ? sugarLevels[0].toString()
                                  : "0",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            // You have eaten and Food Card Section
            const Text(
              "You have Eaten",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            if (_selectedFoods.isEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SugarIntake()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fastfood_outlined,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No Foods Added Yet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to add foods in Sugar Intake Screen",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // Display last 3 foods (most recent first)
            else
              ..._selectedFoods.reversed.take(3).map((product) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildFoodCard(
                    product.productName ?? "Unknown Food",
                    _getSugarContent(product),
                    product.imageFrontUrl,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

// Helper widget for food cards
  Widget _buildFoodCard(
      String foodName, String sugarContent, String? imageUrl) {
    return Card(
      color: const Color(0xFFFBECEC),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/food.jpg",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      "assets/food.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 16),
            // Details of the Food such as the Sugar Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  sugarContent,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
