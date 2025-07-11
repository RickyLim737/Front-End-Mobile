import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  final Map<String, double> itemQuantities;
  final int maxItems;
  final List<Map<String, dynamic>> items; // Tambahkan items yang lengkap

  const StatisticsPage({
    Key? key,
    required this.itemQuantities,
    required this.maxItems,
    required this.items, // Kirimkan items ke sini
  }) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentProgress = 0.0;

  // Menghitung total item berdasarkan quantity yang ada
  int get totalItems =>
      widget.itemQuantities.values
          .fold(0.0, (sum, qty) => sum + qty)
          .toInt(); // Menggunakan double sebagai penampung nilai qty

  // Menghitung total poin yang terkumpul berdasarkan berat dan poin per kg
  double calculateTotalPoints() {
    double totalPoints = 0;
    widget.itemQuantities.forEach((key, value) {
      var item = widget.items.firstWhere((item) => item['name'] == key);
      totalPoints +=
          (item['pointsPerKg'] as double) *
          value; // Menggunakan double untuk menghindari truncation
    });
    return totalPoints;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _updateProgress();
  }

  @override
  void didUpdateWidget(covariant StatisticsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProgress();
  }

  void _updateProgress() {
    double newProgress = (totalItems / widget.maxItems).clamp(0.0, 1.0);
    _animation = Tween<double>(
      begin: _currentProgress,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(from: 0);
    _currentProgress = newProgress;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Daur Ulang'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jumlah Item Didaur Ulang:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.itemQuantities.entries.map(
              (entry) =>
                  Text('- ${entry.key}: ${entry.value.toStringAsFixed(2)} kg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Progress Keseluruhan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 150,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _animation.value,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                        minHeight: 10,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  'Progress: ${(_animation.value * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Poin yang terkumpul: ${calculateTotalPoints()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
