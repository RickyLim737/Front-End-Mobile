import 'package:flutter/material.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _ownerPasswordController = TextEditingController();

  bool _showOwnerField = false;

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _handleLogin() {
    final email = _emailController.text;
    final name = _nameController.text;

    if (!_validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format email tidak valid."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => HomePage(
              userName: name,
              userEmail: email,
              showWelcomeMessage: true,
            ),
      ),
    );
  }

  void _toggleOwnerLogin() {
    setState(() {
      _showOwnerField = !_showOwnerField;
    });
  }

  void _handleOwnerLogin() {
    final password = _ownerPasswordController.text;

    if (password != 'katamsojaya') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password salah. Coba lagi."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => const HomePage(
              userName: 'Owner',
              userEmail: 'owner@katamso.com',
              showWelcomeMessage: true,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text("Login"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade400),
                TextButton.icon(
                  onPressed: _toggleOwnerLogin,
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("Login sebagai Owner"),
                ),
                if (_showOwnerField) ...[
                  TextField(
                    controller: _ownerPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password Owner",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _handleOwnerLogin,
                    child: const Text("Masuk sebagai Owner"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
