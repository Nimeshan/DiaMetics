import 'package:flutter/material.dart';
import 'HamburgerMenu.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

class FirstRecipe extends StatelessWidget {
  const FirstRecipe({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button along with its routing function to the previous Screen
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
              const SizedBox(height: 16),
              // Picture used in the Recipe
              Center(
                child: Image.asset(
                  'assets/RecipePic.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              // Heading for the Recipe
              const SizedBox(height: 16),
              const Text(
                'Diabetic Friendly Pizza',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Recipe Content
              const SizedBox(height: 8),
              const Text(
                "Diabetic-Friendly Pizza Recipe: Create a delicious, diabetes-conscious pizza by starting with a low-carb crust like cauliflower or whole grain.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Text(
                "Spread a thin layer of sugar-free marinara sauce and top with non-starchy vegetables like spinach, bell peppers, mushrooms, and onions. Add a modest amount of low-fat mozzarella or a plant-based cheese alternative, and include a protein like grilled chicken or turkey sausage for balance.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Text(
                "Sprinkle with fresh basil, oregano, or chili flakes for added flavor. Bake at 425°F (220°C) for 12-15 minutes until golden and bubbly.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Text(
                "Pair with a simple green salad or enjoy on its own for a wholesome, satisfying meal. It's a tasty way to enjoy pizza while staying mindful of your health! Check out our other recipes that are diabetic friendly.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
