import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'konsumsi_bijak_page.dart';
import 'detail_page.dart';
import 'daur_ulang.dart';
import 'kurangi_sampah.dart';
import 'login_page.dart';
import 'reedem_point.dart';

class HomePage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final bool showWelcomeMessage;
  final int? totalPoints;

  const HomePage({
    super.key,
    this.userName,
    this.userEmail,
    this.showWelcomeMessage = false,
    this.totalPoints,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> features = [
    {
      'title': 'Konsumsi Bijak',
      'desc':
          'Belajar memilih barang yang ramah lingkungan dan tidak berlebihan.',
      'imageUrl':
          'https://cdn.pixabay.com/photo/2017/01/20/00/05/good-luck-1993688_1280.jpg',
    },
    {
      'title': 'Kurangi Sampah',
      'desc':
          'Kenali pentingnya mengurangi limbah dengan tindakan kecil sehari-hari.',
      'imageUrl':
          'https://images.unsplash.com/photo-1528323273322-d81458248d40',
    },
    {
      'title': 'Daur Ulang',
      'desc': 'Ubah barang bekas menjadi sesuatu yang bermanfaat dan menarik.',
      'imageUrl':
          'https://cdn.pixabay.com/photo/2018/04/08/19/55/bottles-3302316_1280.jpg',
    },
  ];

  String? selectedTitle;
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
    if (widget.showWelcomeMessage && widget.userName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login berhasil. Selamat datang, ${widget.userName}!",
            ),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = prefs.getInt('totalPoints') ?? widget.totalPoints ?? 0;
    });
  }

  Future<void> _bukaKurangiSampah() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KurangiSampahPage()),
    );

    if (hasil is int && hasil > 0) {
      final prefs = await SharedPreferences.getInstance();
      final poinSebelumnya = prefs.getInt('totalPoints') ?? 0;
      final totalBaru = poinSebelumnya + hasil;

      await prefs.setInt('totalPoints', totalBaru);

      setState(() {
        totalPoints = totalBaru;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil menambahkan $hasil poin!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _getUserStatus(int points) {
    if (points >= 500) return "Platinum";
    if (points >= 300) return "Diamond";
    if (points >= 100) return "Silver";
    return "Bronze";
  }

  @override
  Widget build(BuildContext context) {
    final selectedFeature = features.firstWhere(
      (f) => f['title'] == selectedTitle,
      orElse: () => {},
    );

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text("Konsumsi & Produksi Berkelanjutan"),
        backgroundColor: Colors.green.shade700,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: (totalPoints.clamp(0, 500)) / 500,
                        ),
                        duration: Duration(seconds: 1),
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName ?? 'cynakatamso',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.userEmail ?? 'cynakatamso@gmail.com',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Poin: $totalPoints",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => RedeemPointsPage(
                                          totalPoints: totalPoints,
                                          userName:
                                              widget.userName ?? 'cynakatamso',
                                          userEmail:
                                              widget.userEmail ??
                                              'cynakatamso@gmail.com',
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                "Tukar Poin",
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Status: ${_getUserStatus(totalPoints)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Login"),
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text("Konsumsi Bijak"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => KonsumsiBijakPage()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.reduce_capacity),
              title: Text("Kurangi Sampah"),
              onTap: _bukaKurangiSampah,
            ),
            ListTile(
              leading: Icon(Icons.recycling),
              title: Text("Daur Ulang"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RecycleCheckerPage(
                            userName: widget.userName ?? 'cynakatamso',
                            userEmail:
                                widget.userEmail ?? 'cynakatamso@gmail.com',
                          ),
                    ),
                  ),
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs
                    .clear(); // Ini akan menghapus totalPoints, userName, userEmail, dll.

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat datang!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Pilih topik untuk belajar lebih lanjut tentang gaya hidup ramah lingkungan.",
              style: TextStyle(fontSize: 16, color: Colors.green.shade700),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTitle,
                  hint: Text("Pilih Topik"),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.green.shade700,
                  ),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String>(value: null, child: Text("Tutup")),
                    ...features.map((feature) {
                      return DropdownMenuItem<String>(
                        value: feature['title'],
                        child: Text(feature['title']!),
                      );
                    }),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedTitle = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child:
                  (selectedFeature.isNotEmpty)
                      ? FeatureCard(
                        selectedFeature: selectedFeature,
                        onKurangiSampahTap: _bukaKurangiSampah,
                        userName: widget.userName ?? 'cynakatamso',
                        userEmail: widget.userEmail ?? 'cynakatamso@gmail.com',
                      )
                      : PlaceholderCard(),
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              color: Colors.green.shade700,
              child: Center(
                child: Text(
                  'CopyRight ©2025 by ${widget.userName ?? "cynakatamso"}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final Map<String, String> selectedFeature;
  final VoidCallback? onKurangiSampahTap;
  final String userName;
  final String userEmail;

  const FeatureCard({
    required this.selectedFeature,
    this.onKurangiSampahTap,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(selectedFeature['title']),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              selectedFeature['imageUrl']!,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Center(child: Icon(Icons.broken_image)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              selectedFeature['desc'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                final title = selectedFeature['title'];
                if (title == 'Konsumsi Bijak') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => KonsumsiBijakPage()),
                  );
                } else if (title == 'Daur Ulang') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RecycleCheckerPage(
                            userName: userName,
                            userEmail: userEmail,
                          ),
                    ),
                  );
                } else if (title == 'Kurangi Sampah') {
                  if (onKurangiSampahTap != null) {
                    onKurangiSampahTap!();
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => DetailPage(
                            title: selectedFeature['title']!,
                            description: selectedFeature['desc']!,
                            imageUrl: selectedFeature['imageUrl']!,
                          ),
                    ),
                  );
                }
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("Pelajari Lebih Lanjut"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey("placeholder"),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset('download.jpeg', height: 300, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
