import 'package:flutter/material.dart';
import 'dart:async';
import 'pilih_makanan_page.dart';

class KonsumsiBijakPage extends StatefulWidget {
  const KonsumsiBijakPage({super.key});

  @override
  _KonsumsiBijakPageState createState() => _KonsumsiBijakPageState();
}

class _KonsumsiBijakPageState extends State<KonsumsiBijakPage> {
  int _currentIndex = 0;
  late Timer _timer;

  final List<String> _images = ['gambar1.jpeg', 'gambar2.jpeg', 'gambar3.jpeg'];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konsumsi Bijak"),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pilih kategori konsumsi yang bijak!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Lihat gambar berikut untuk mendapatkan tips seputar konsumsi bijak!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: Container(
                  alignment: Alignment.center,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade700, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      _images[_currentIndex],
                      key: ValueKey<int>(_currentIndex),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PilihMakananPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Pilih Makanan Bijak'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
