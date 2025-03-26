import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diametics/Screens/HospitalLocator.dart';
import 'HamburgerMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DiabeticLevel());
}

class DiabeticLevel extends StatefulWidget {
  const DiabeticLevel({super.key});

  @override
  _DiabeticLevelState createState() => _DiabeticLevelState();
}

class _DiabeticLevelState extends State<DiabeticLevel> {
  final TextEditingController _sugarController = TextEditingController();
  List<int> sugarLevels = [];

  @override
  void initState() {
    super.initState();
    _loadSugarLevels();
  }

  Future<void> _loadSugarLevels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('sugar_levels');

    setState(() {
      sugarLevels =
          storedData != null ? List<int>.from(json.decode(storedData)) : [];
    });
  }

  Future<void> _addSugarLevel() async {
    int sugarLevel = int.tryParse(_sugarController.text) ?? 0;
    if (sugarLevel > 0) {
      setState(() {
        sugarLevels.insert(0, sugarLevel);
        if (sugarLevels.length > 14) {
          sugarLevels.removeLast();
        }
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('sugar_levels', json.encode(sugarLevels));

      await _uploadToFirebase();

      _sugarController.clear();
    }
  }

  Future<void> _uploadToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in");
        return;
      }

      String filePath = 'sugar_levels/${user.uid}.json';
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);

      String jsonData = json.encode(sugarLevels);

      await storageRef.putString(jsonData, format: PutStringFormat.raw);

      print("Sugar levels uploaded successfully");
    } catch (e) {
      print("Error uploading sugar levels: $e");
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Add Sugar Level",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _sugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Sugar Level',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addSugarLevel,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC8C34C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(470, 0),
              ),
              child: const Text(
                'Add Sugar Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Last 14 Days Sugar Levels:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: sugarLevels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Day ${index + 1}: ${sugarLevels[index]} mg/dl',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
