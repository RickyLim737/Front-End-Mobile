import 'package:flutter/material.dart';
import 'package:uts/food_list.dart';
import 'package:uts/food_data.dart';
import 'summary_page.dart';

class StatisticsPage extends StatelessWidget {
  final int totalCalories;
  final List<Map<String, dynamic>> selectedFoods;

  const StatisticsPage({
    Key? key,
    required this.totalCalories,
    required this.selectedFoods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int targetCalories = 2600;
    double percentageAchieved = (totalCalories / targetCalories) * 100;

    if (percentageAchieved > 100) percentageAchieved = 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistik Kalori'),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Colors.green.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Kalori yang Dicapai: $totalCalories / $targetCalories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Persentase yang Tercapai: ${percentageAchieved.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(height: 20),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: percentageAchieved),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: value / 100,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.green.shade700,
                      minHeight: 20,
                    ),
                    SizedBox(height: 10),
                    Text(
                      value >= 100
                          ? 'Selamat! Anda telah mencapai atau melebihi target kalori harian.'
                          : 'Teruskan! Anda masih ${(100 - value).toStringAsFixed(2)}% lagi untuk mencapai target.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: value >= 100 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status Kalori:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  percentageAchieved >= 100
                      ? 'Overachieved'
                      : percentageAchieved < 100 && percentageAchieved >= 90
                      ? 'Almost There'
                      : 'Belum Cukup',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        percentageAchieved >= 100
                            ? Colors.green
                            : percentageAchieved < 100 &&
                                percentageAchieved >= 90
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FoodList(selectedFoods: selectedFoods),
          ],
        ),
      ),
    );
  }
}
