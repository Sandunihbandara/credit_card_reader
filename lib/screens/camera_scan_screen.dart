import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_storage.dart';

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with SingleTickerProviderStateMixin {
  bool isScanning = false;

  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scanAnimation =
        Tween<double>(begin: -1, end: 1).animate(_scanController);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void startFakeScan() async {
    setState(() {
      isScanning = true;
    });

    // Fake delay (like real scanning)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isScanning = false;
    });

    // ✅ SAVE CARD HERE (STEP 4)
    CardStorage.addCard(
      CardModel(
        number: "1234 5678 9012 3456",
        name: "JOHN DOE",
        expiry: "05/28",
        type: "CAMERA",
      ),
    );

    // Show result
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Card Saved"),
        content: const Text("Scanned card saved successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF112D6B);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Scan Card"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fake camera background
          Container(
            color: Colors.black,
          ),

          // Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Align your card inside the frame",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // Card frame
                Container(
                  width: 300,
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Stack(
                    children: [
                      // Scanning line animation
                      AnimatedBuilder(
                        animation: _scanAnimation,
                        builder: (context, child) {
                          return Align(
                            alignment:
                            Alignment(0, _scanAnimation.value),
                            child: Container(
                              height: 2,
                              width: double.infinity,
                              color: Colors.greenAccent,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  isScanning ? "Scanning..." : "Ready to scan",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Capture button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: isScanning ? null : startFakeScan,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isScanning
                        ? Colors.grey
                        : primaryBlue,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}