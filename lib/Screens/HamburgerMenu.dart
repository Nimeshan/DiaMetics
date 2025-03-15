import 'package:diametics/Screens/DiabeticLevel.dart';
import 'package:diametics/Screens/SugarIntake.dart';
import 'package:diametics/Screens/HomePage.dart';
import 'package:diametics/Screens/Exercise.dart';
import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          Container(
            color: const Color(0xFFD4E157),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/profile.png"),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Jeffery Daniel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Diabetic Level'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DiabeticLevel()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Sugar Intake'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SugarIntake()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Exercise'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Exercises()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Recipes'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Scaffold(drawer: HamburgerMenu())));
}
