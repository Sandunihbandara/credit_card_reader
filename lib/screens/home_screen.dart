import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/google_auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final googleAuthService = GoogleAuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}