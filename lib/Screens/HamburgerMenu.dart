import 'package:diametics/Screens/DiabeticLevel.dart';
import 'package:diametics/Screens/SugarIntake.dart';
import 'package:diametics/Screens/HomePage.dart';
import 'package:diametics/Screens/Exercise.dart';
import 'package:diametics/Screens/Recipes.dart';
import 'package:diametics/Screens/Account.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: const Color(0xFFD4E157),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // User Profile Image
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage("assets/profile.png") as ImageProvider,
                ),
                const SizedBox(height: 10),
                // User Name if the user is not logged in it ouputs Guest User
                Text(
                  user?.displayName ?? 'Guest User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Items of the Hamburger Menu such as the Routing to Home Page, Sugar Intake Page, etc.
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
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Recipes()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Account()));
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Scaffold(drawer: HamburgerMenu())));
}
