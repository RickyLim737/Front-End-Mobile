import 'package:flutter/material.dart';
import 'statisticspage.dart';
import 'food_list.dart';

class SummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedFoods;

  const SummaryPage({super.key, required this.selectedFoods});

  @override
  Widget build(BuildContext context) {
    int totalCalories = selectedFoods.fold(0, (sum, food) {
      final calories = food['calories'];
      return sum + (calories is int ? calories : 0);
    });

    String status;
    Color statusColor;

    if (totalCalories >= 2000 && totalCalories <= 2600) {
      status = 'Konsumsi kalori sudah seimbang.';
      statusColor = Colors.green;
    } else if (totalCalories > 2600 && totalCalories <= 2650) {
      status = 'Konsumsi kalori sedikit melebihi batas.';
      statusColor = Colors.orange;
    } else if (totalCalories < 2000) {
      status = 'Konsumsi kalori belum seimbang.';
      statusColor = Colors.red;
    } else {
      status = 'Konsumsi kalori OVER!';
      statusColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ringkasan Konsumsi'),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Colors.green.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            selectedFoods.isEmpty
                ? Center(
                  child: Text(
                    'Tidak ada konsumsi yang dipilih.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green.shade700,
                    ),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konsumsi yang Dipilih:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedFoods.length,
                        itemBuilder: (context, index) {
                          final food = selectedFoods[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Image.network(
                                food['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(food['title']),
                              subtitle: Text(
                                '${food['desc']}\nKalori: ${food['calories']}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Kalori: $totalCalories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 16,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StatisticsPage(
                                  totalCalories: totalCalories,
                                  selectedFoods: selectedFoods,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Lihat Statistik'),
                    ),
                  ],
                ),
      ),
    );
  }
}
