import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:openfoodfacts/openfoodfacts.dart' as openfood;
import 'package:diametics/Screens/HospitalLocator.dart';
import 'HamburgerMenu.dart';

class Barcode extends StatefulWidget {
  const Barcode({super.key});

  @override
  State<Barcode> createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  //Camera Controller for Mobile Scanner, as well as the loading state of it and stores the scanned product data
  mobile_scanner.MobileScannerController cameraController =
      mobile_scanner.MobileScannerController();
  bool _isLoading = false;
  openfood.ProductResultV3? _scannedProduct;

  @override
  // Configuration for OpenFoodFacts API settings
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
  }

  // Fetches product details using the scanned barcode
  Future<void> _fetchProductByBarcode(String barcode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final product = await openfood.OpenFoodAPIClient.getProductV3(
        openfood.ProductQueryConfiguration(
          barcode,
          version: openfood.ProductQueryVersion.v3,
          language: openfood.OpenFoodFactsLanguage.ENGLISH,
          country: openfood.OpenFoodFactsCountry.USA,
          fields: [
            openfood.ProductField.NAME,
            openfood.ProductField.IMAGE_FRONT_URL,
            openfood.ProductField.NUTRIMENTS,
          ],
        ),
      );

      if (product.status == 1) {
        setState(() {
          _scannedProduct = product;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product not found.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching product: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Adds the scanned product to sugar intake and returns to previous screen
  void _addScannedProductToSugarIntake(BuildContext context) {
    if (_scannedProduct != null) {
      Navigator.pop(context, _scannedProduct);
    }
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Scan Barcode",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Back Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back"),
              ),
              // Barcode scanner widget
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: mobile_scanner.MobileScanner(
                  controller: cameraController,
                  onDetect: (capture) {
                    final List<mobile_scanner.Barcode> barcodes =
                        capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final String barcode = barcodes.first.rawValue ?? '';
                      _fetchProductByBarcode(barcode);
                    }
                  },
                ),
              ),
              // Show loading indicator or product info
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_scannedProduct != null)
                Column(
                  children: [
                    ListTile(
                      leading: _scannedProduct!.product?.imageFrontUrl != null
                          ? Image.network(
                              _scannedProduct!.product!.imageFrontUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.fastfood, size: 50),
                      title: Text(
                        _scannedProduct!.product?.productName ?? "Unknown Food",
                      ),
                      subtitle:
                          Text("Sugar: ${_getSugarContent(_scannedProduct!)}"),
                    ),
                    // Button to add product to sugar intake
                    ElevatedButton(
                      onPressed: () => _addScannedProductToSugarIntake(context),
                      child: const Text("Add to Sugar Intake"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSugarContent(openfood.ProductResultV3 product) {
    double? sugarContent = product.product?.nutriments?.getValue(
      openfood.Nutrient.sugars,
      openfood.PerSize.oneHundredGrams,
    );
    return sugarContent != null ? '${sugarContent.toStringAsFixed(1)}g' : 'N/A';
  }
}
