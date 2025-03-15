import 'package:flutter/material.dart';
import 'HamburgerMenu.dart';

void main() {
  runApp(const DiabeticLevel());
}

class DiabeticLevel extends StatelessWidget {
  const DiabeticLevel({super.key});

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
        drawer: const HamburgerMenu(), // Attach the drawer
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              "Add Sugar Level",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Sugar Level',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC8C34C),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                padding: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(470, 0),
              ),
              child: Text(
                'Add Sugar Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6CEAC0),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                padding: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(470, 0),
              ),
              child: Text(
                'Connect Glucometer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
