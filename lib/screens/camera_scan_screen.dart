import 'package:flutter/material.dart';

class CameraScanScreen extends StatelessWidget {
  const CameraScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Scan")),
      body: const Center(
        child: Text(
          "Camera scanning coming next 🔥",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}