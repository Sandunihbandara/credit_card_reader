import 'package:flutter/material.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Virtual Card')),
      body: const Center(
        child: Text(
          'Virtual card form page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}