import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCSQ_EwoOyFFra1P55VM2lrQ7v-PR_En8w",
        authDomain: "diametics-90bd8.firebaseapp.com",
        projectId: "diametics-90bd8",
        storageBucket: "diametics-90bd8.firebasestorage.app",
        messagingSenderId: "862563017151",
        appId: "1:862563017151:web:370f3d5a891a96e35f810a",
      ),
    );
    debugPrint("Firebase initialized successfully!");
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DiaMetics",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}
