import 'package:flutter/material.dart';
import 'food_data.dart';
import 'summary_page.dart';

class PilihMakananPage extends StatefulWidget {
  const PilihMakananPage({super.key});

  @override
  _PilihMakananPageState createState() => _PilihMakananPageState();
}

class _PilihMakananPageState extends State<PilihMakananPage> {
  List<Map<String, dynamic>> selectedFoods = [];
  String selectedCategory = 'Semua';

  List<String> categories = ['Semua', 'Makanan', 'Minuman'];

  List<Map<String, dynamic>> get filteredFoods {
    if (selectedCategory == 'Semua') return healthyFoods;
    return healthyFoods
        .where((food) => food['category'] == selectedCategory)
        .toList();
  }

  int calculateTotalCalories() {
    return selectedFoods.fold(0, (sum, food) {
      final calories = food['calories'];
      return sum + (calories is int ? calories : 0);
    });
  }

  void toggleSelection(Map<String, dynamic> food) {
    setState(() {
      if (selectedFoods.contains(food)) {
        selectedFoods.remove(food);
      } else {
        selectedFoods.add(food);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Konsumsi Bijak'),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items:
                  categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                final isSelected = selectedFoods.contains(food);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    isThreeLine: true,
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (_) => toggleSelection(food),
                    ),
                    onTap: () => toggleSelection(food),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total Kalori: ${calculateTotalCalories()}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ),
          ElevatedButton(
            onPressed:
                selectedFoods.isEmpty
                    ? null
                    : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SummaryPage(selectedFoods: selectedFoods),
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
            child: Text(
              'Lihat Ringkasan',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
