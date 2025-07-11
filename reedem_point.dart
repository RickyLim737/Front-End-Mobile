import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class RedeemPointsPage extends StatefulWidget {
  final int totalPoints;
  final String userName;
  final String userEmail;

  const RedeemPointsPage({
    super.key,
    required this.totalPoints,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<RedeemPointsPage> createState() => _RedeemPointsPageState();
}

class _RedeemPointsPageState extends State<RedeemPointsPage> {
  String? selectedMethod;
  String? selectedOption;
  int? pointsToRedeem;
  final TextEditingController _pointsController = TextEditingController();

  final Map<String, List<String>> methodOptions = {
    'Bank': ['Mandiri', 'BCA', 'BRI', 'Bukopin'],
    'E-Wallet': ['OVO', 'GoPay', 'ShopeePay'],
    'QRIS': ['QRIS (Universal)'],
  };

  void _redeem() async {
    final points = int.tryParse(_pointsController.text);
    if (points == null || points <= 0 || points > widget.totalPoints) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Jumlah poin tidak valid.')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPoints', widget.totalPoints - points);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => HomePage(
              showWelcomeMessage: true,
              userName: widget.userName,
              userEmail: widget.userEmail,
              totalPoints: widget.totalPoints - points,
            ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Transaksi selesai: $points poin ditukar ke $selectedOption via $selectedMethod",
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tukar Poin"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Poin Anda: ${widget.totalPoints}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              hint: Text("Pilih Metode"),
              items:
                  methodOptions.keys.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                  selectedOption = null;
                });
              },
            ),
            SizedBox(height: 10),
            if (selectedMethod != null)
              DropdownButtonFormField<String>(
                value: selectedOption,
                hint: Text("Pilih ${selectedMethod!}"),
                items:
                    methodOptions[selectedMethod]!
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedOption = value),
              ),
            SizedBox(height: 10),
            TextFormField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah Poin'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: (selectedOption != null) ? _redeem : null,
              icon: Icon(Icons.check),
              label: Text("Tukar Sekarang"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
