import 'package:flutter/material.dart';
import 'HamburgerMenu.dart';

void main() {
  runApp(const SugarIntake());
}

class SugarIntake extends StatelessWidget {
  const SugarIntake({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2893E),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, size: 20),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.lightbulb, size: 20),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.local_hospital, size: 20),
            ),
          ],
        ),
        drawer: const HamburgerMenu(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              "Add Sugar Intake",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search',
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 3.0, right: 2.0, bottom: 1.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Scan Bar Code Instead',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              color: Color(0xFFFBECEC), // Background color for the card
              elevation: 4, // Adds shadow to the card
              margin: EdgeInsets.symmetric(
                  horizontal: 16), // Adds horizontal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adds inner padding
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners for the image
                      child: Image.asset(
                        "assets/food.jpg", // Replace with your image path
                        width: 50, // Image width
                        height: 50, // Image height
                        fit: BoxFit.cover, // Ensures the image fits nicely
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Food Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "25g sugar",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "You have Eaten",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              color: Color(0xFFFBECEC), // Background color for the card
              elevation: 4, // Adds shadow to the card
              margin: EdgeInsets.symmetric(
                  horizontal: 16), // Adds horizontal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adds inner padding
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners for the image
                      child: Image.asset(
                        "assets/food.jpg", // Replace with your image path
                        width: 50, // Image width
                        height: 50, // Image height
                        fit: BoxFit.cover, // Ensures the image fits nicely
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Food Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "25g sugar",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              color: Color(0xFFFBECEC), // Background color for the card
              elevation: 4, // Adds shadow to the card
              margin: EdgeInsets.symmetric(
                  horizontal: 16), // Adds horizontal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adds inner padding
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners for the image
                      child: Image.asset(
                        "assets/food.jpg", // Replace with your image path
                        width: 50, // Image width
                        height: 50, // Image height
                        fit: BoxFit.cover, // Ensures the image fits nicely
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Food Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "25g sugar",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              color: Color(0xFFFBECEC), // Background color for the card
              elevation: 4, // Adds shadow to the card
              margin: EdgeInsets.symmetric(
                  horizontal: 16), // Adds horizontal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adds inner padding
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners for the image
                      child: Image.asset(
                        "assets/food.jpg", // Replace with your image path
                        width: 50, // Image width
                        height: 50, // Image height
                        fit: BoxFit.cover, // Ensures the image fits nicely
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Food Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "25g sugar",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              color: Color(0xFFFBECEC), // Background color for the card
              elevation: 4, // Adds shadow to the card
              margin: EdgeInsets.symmetric(
                  horizontal: 16), // Adds horizontal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adds inner padding
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Rounded corners for the image
                      child: Image.asset(
                        "assets/food.jpg", // Replace with your image path
                        width: 50, // Image width
                        height: 50, // Image height
                        fit: BoxFit.cover, // Ensures the image fits nicely
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Food Name",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "25g sugar",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
