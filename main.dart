import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoLife App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Arial'),
      home: CoverPage(), // Tetap tampilkan CoverPage dulu
    );
  }
}

class CoverPage extends StatelessWidget {
  const CoverPage({super.key});

  Future<void> _navigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final totalPoints = prefs.getInt('totalPoints') ?? 0;

    // Simulasi user default (bisa kamu sesuaikan)
    final userName = prefs.getString('userName') ?? 'cynakatamso';
    final userEmail = prefs.getString('userEmail') ?? 'cynakatamso@gmail.com';

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => HomePage(
                userName: userName,
                userEmail: userEmail,
                totalPoints: totalPoints,
                showWelcomeMessage: true,
              ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('image.png', height: 150),
              SizedBox(height: 20),
              Text(
                "Responsible Consumption & Production",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Bersama kita wujudkan konsumsi dan produksi yang berkelanjutan untuk masa depan bumi yang lebih baik.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green.shade700),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _navigate(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.green.shade700,
                ),
                child: Text(
                  "Mulai",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
