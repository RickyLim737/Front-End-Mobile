import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KurangiSampahPage extends StatefulWidget {
  @override
  _KurangiSampahPageState createState() => _KurangiSampahPageState();
}

class _KurangiSampahPageState extends State<KurangiSampahPage> {
  bool _showTips = false;
  int _totalKarbonTerselamatkan = 0;
  int _rewardPoints = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  List<Map<String, String>> _dataSampah = [];

  double _hitungKarbonTerselamatkan(double jumlahGram) {
    return jumlahGram * 0.1;
  }

  void _toggleTips() {
    setState(() {
      _showTips = !_showTips;
    });
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final jenis = _jenisController.text.trim().toLowerCase();
      final jumlahText = _jumlahController.text.trim();

      if (_containsNumber(jenis)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jenis sampah tidak sesuai')),
        );
        return;
      }

      final jumlah = double.tryParse(jumlahText);
      if (jumlah == null || jumlah <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Masukkan jumlah yang valid')),
        );
        return;
      }

      double jumlahGram = jumlah;
      double karbonTerselamatkan = _hitungKarbonTerselamatkan(jumlahGram);

      setState(() {
        _dataSampah.add({
          'jenis': jenis,
          'jumlah': '${jumlahGram.toInt()} gram',
        });
        _jenisController.clear();
        _jumlahController.clear();

        _totalKarbonTerselamatkan += karbonTerselamatkan.toInt();
        _rewardPoints += karbonTerselamatkan.toInt();
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Data Tersimpan"),
          content: Text("Data berhasil disimpan."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Gagal"),
          content: Text("Data tidak berhasil disimpan."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _simpanTotalPoint() async {
    final prefs = await SharedPreferences.getInstance();
    int previous = prefs.getInt('totalPoints') ?? 0;
    int newTotal = previous + _rewardPoints;
    bool success = await prefs.setInt('totalPoints', newTotal);

    if (success) {
      Navigator.pop(context, _rewardPoints); // ✅ Kembalikan poin ke HomePage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan total poin.")),
      );
    }
  }

  bool _containsNumber(String s) {
    return s.contains(RegExp(r'\d'));
  }

  @override
  void dispose() {
    _jenisController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('Kurangi Sampah'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edukasi Pengurangan Sampah',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Mengurangi sampah dapat dimulai dari kebiasaan sehari-hari seperti membawa tas belanja sendiri, menghindari plastik sekali pakai, dan memilah sampah.',
                style: TextStyle(fontSize: 16, color: Colors.green.shade700),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _toggleTips,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(_showTips ? Icons.expand_less : Icons.expand_more),
                  label: Text(_showTips ? 'Sembunyikan Tips' : 'Tampilkan Tips'),
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(milliseconds: 600),
                opacity: _showTips ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  width: double.infinity,
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _showTips
                        ? [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: _showTips
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tips Mengurangi Sampah:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("• Gunakan botol minum isi ulang."),
                            Text("• Pilih produk dengan kemasan minimal."),
                            Text("• Donasikan atau jual barang bekas."),
                            Text("• Hindari penggunaan tisu berlebihan."),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Input Sampah yang Dibuang',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _jenisController,
                        decoration: InputDecoration(
                          labelText: 'Jenis Sampah (misal: plastik)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Wajib diisi';
                          }
                          if (_containsNumber(value.trim().toLowerCase())) {
                            return 'Jenis sampah tidak sesuai';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _jumlahController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah (angka, dianggap gram)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Wajib diisi';
                          }
                          final jumlah = double.tryParse(value.trim());
                          if (jumlah == null || jumlah <= 0) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _submitData,
                      icon: Icon(Icons.save),
                      label: Text('Simpan Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_dataSampah.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Sampah yang Dimasukkan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    ..._dataSampah.map(
                      (data) => ListTile(
                        leading: Icon(Icons.delete_sweep, color: Colors.green),
                        title: Text(data['jenis']!),
                        subtitle: Text('Jumlah: ${data['jumlah']}'),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 30),
              Text(
                'Karbon yang Diselamatkan: $_totalKarbonTerselamatkan gram',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Reward Points: $_rewardPoints poin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpanTotalPoint,
                icon: Icon(Icons.check),
                label: Text('Simpan Total Point'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
