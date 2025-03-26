import 'package:flutter/material.dart';
import 'HamburgerMenu.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

class SecondRecipe extends StatelessWidget {
  const SecondRecipe({super.key});

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
              Center(
                child: Image.asset(
                  'assets/avocado.jpeg',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Diabetic-Friendly Avocado Egg Salad',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mash 1 ripe avocado and mix it with 2 chopped boiled eggs, a squeeze of lemon juice, a pinch of salt, and black pepper. Add some finely chopped cucumbers or onions for crunch.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Text(
                'Enjoy it on whole-grain toast or as a lettuce wrap for a low-carb option. Quick, healthy, and packed with good fats and protein! 🥑🥚✨',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
