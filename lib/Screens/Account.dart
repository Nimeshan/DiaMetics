import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diametics/Screens/HospitalLocator.dart';
import 'HamburgerMenu.dart';
import 'Login.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    // Gets the Currently Logged in User with the help of Firebase
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // AppBar with menu button and hospital locator icon
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2893E),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, size: 20),
              onPressed: () {
                // Opens the drawer when pressed
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        // Navigates to HospitalLocator screen When the Icon is pressed
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User profile picture (CircleAvatar)
              // Shows the Image of the Google Account as a profile picture else shows a default picture
              CircleAvatar(
                radius: 67,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage("assets/profile.png") as ImageProvider,
              ),
              const SizedBox(height: 10),
              // Shows user's display name (or "Guest User" if not logged in)
              Text(
                user?.displayName ?? 'Guest User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                user?.email ?? 'No email found',
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              // Logout Button and the Functions of it
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 228, 78, 67),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
