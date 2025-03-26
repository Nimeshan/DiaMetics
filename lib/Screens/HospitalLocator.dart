import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HamburgerMenu.dart';

class HospitalLocator extends StatelessWidget {
  const HospitalLocator({super.key});

  void _callEmergency(BuildContext context) async {
    final Uri callUri = Uri.parse("tel:999");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch call")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2893E),
        title: const Text("Hospital Locator", style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_hospital, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HospitalLocator()),
              );
            },
          ),
        ],
      ),
      drawer: const HamburgerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Diabetic Emergency",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Are you or someone experiencing a Diabetic Emergency? Call NHS for help.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _callEmergency(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4C44C),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: const Text(
                  "Call NHS 999",
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
