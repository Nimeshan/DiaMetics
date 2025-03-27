import 'package:flutter/material.dart';
import 'HamburgerMenu.dart';
import 'FirstRecipe.dart';
import 'SecondRecipe.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

void main() {
  runApp(const Recipes());
}

class Recipes extends StatelessWidget {
  const Recipes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Diabetic Friendly Recipes",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                // Following Section has the Recipe Cards
                FoodCard(
                  title: "Diabetic Friendly Pizza",
                  subtitle: "Recipe 1",
                  imagePath: "assets/RecipePic.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirstRecipe()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                FoodCard(
                  title: "Diabetic-Friendly Avocado Egg Salad",
                  subtitle: "Recipe 2",
                  imagePath: "assets/avocado.jpeg",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondRecipe()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Set up for Reusable Recipe Cards
class FoodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

// Styling for Recipe Cards such as Colors, and Radius used for it
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
