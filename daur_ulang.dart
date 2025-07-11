import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'statistic_recycle.dart';
import 'homepage.dart';

void main() {
  runApp(
    MaterialApp(
      home: RecycleCheckerPage(
        userName: 'userLoginName',
        userEmail: 'user@example.com',
      ),
    ),
  );
}

class RecycleCheckerPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const RecycleCheckerPage({
    Key? key,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  _RecycleCheckerPageState createState() => _RecycleCheckerPageState();
}

class _RecycleCheckerPageState extends State<RecycleCheckerPage> {
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Botol Plastik',
      'isRecyclable': true,
      'pointsPerKg': 10,
      'weight': 0.5,
    },
    {
      'name': 'Kantong Kresek',
      'isRecyclable': false,
      'pointsPerKg': 0,
      'weight': 0.1,
    },
    {
      'name': 'Sedotan Plastik',
      'isRecyclable': false,
      'pointsPerKg': 0,
      'weight': 0.02,
    },
    {'name': 'Kaca', 'isRecyclable': true, 'pointsPerKg': 15, 'weight': 0.3},
    {
      'name': 'Styrofoam',
      'isRecyclable': false,
      'pointsPerKg': 0,
      'weight': 0.4,
    },
  ];

  final int maxItems = 10;
  int totalPoints = 0;
  int sessionPoints = 0;
  int previousPoints = 0;
  Map<String, double> itemQuantities = {};
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _resetItemQuantities();
    _loadPoints();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _resetItemQuantities() {
    for (var item in items) {
      itemQuantities[item['name']] = 0.0;
    }
  }

  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', totalPoints);
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = prefs.getInt('totalPoints') ?? 0;
      previousPoints = totalPoints;
    });
  }

  void _incrementItem(Map<String, dynamic> item) {
    final itemName = item['name'];
    final pointsPerKg = item['pointsPerKg'] as int;
    final weight = item['weight'] as double;
    final earned = (pointsPerKg * weight).round();

    setState(() {
      itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) + weight;
      totalPoints += earned;
      sessionPoints += earned;
      if (totalPoints % 50 == 0) {
        _confettiController.play();
      }
    });
  }

  void _decrementItem(Map<String, dynamic> item) {
    final itemName = item['name'];
    final pointsPerKg = item['pointsPerKg'] as int;
    final weight = item['weight'] as double;
    final lost = (pointsPerKg * weight).round();

    if ((itemQuantities[itemName] ?? 0) <= 0) return;

    setState(() {
      itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) - weight;
      totalPoints -= lost;
      sessionPoints -= lost;
    });
  }

  void _showPointsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Poin yang Dikumpulkan'),
          content: Text('Total poin yang berhasil dikumpulkan: $totalPoints'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _saveAndReturnHome() async {
    await _savePoints();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Poin Disimpan"),
            content: Text(
              "Poin sebelumnya: $previousPoints\n"
              "Poin didapatkan dari sesi ini: $sessionPoints\n"
              "Total poin sekarang: $totalPoints",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => HomePage(
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                            totalPoints: totalPoints,
                          ),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Daur Ulang'),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Colors.green.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih jenis sampah:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final itemName = item['name'];
                  final quantity = itemQuantities[itemName] ?? 0;

                  return Card(
                    child: ListTile(
                      title: Text(itemName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed:
                                quantity > 0
                                    ? () => _decrementItem(item)
                                    : null,
                          ),
                          Text('${quantity.toStringAsFixed(2)} kg'),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                            onPressed: () => _incrementItem(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showPointsDialog,
                child: const Text("Lihat Poin"),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StatisticsPage(
                            itemQuantities: itemQuantities,
                            maxItems: maxItems,
                            items: items,
                          ),
                    ),
                  );
                },
                child: const Text("Lihat Statistik Daur Ulang"),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _saveAndReturnHome,
                child: const Text("Simpan & Kembali ke Beranda"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [Colors.green, Colors.blue, Colors.orange],
      ),
    );
  }
}
