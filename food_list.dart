import 'package:flutter/material.dart';

class FoodList extends StatelessWidget {
  final List<Map<String, dynamic>> selectedFoods;

  const FoodList({Key? key, required this.selectedFoods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              subtitle: Text('${food['desc']}\nKalori: ${food['calories']}'),
            ),
          );
        },
      ),
    );
  }
}
