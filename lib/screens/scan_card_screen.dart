import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_storage.dart';

class ScanCardScreen extends StatefulWidget {
  const ScanCardScreen({super.key});

  @override
  State<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends State<ScanCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startScan() async {
    setState(() {
      isScanning = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      isScanning = false;
    });

    CardStorage.addCard(
      CardModel(
        number: "9999 8888 7777 6666",
        name: "NFC USER",
        expiry: "08/30",
        type: "NFC",
      ),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Card Detected'),
        content: const Text(
          'Demo scan completed successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF112D6B);
    const darkBlue = Color(0xFF0D1B4C);
    const lightBg = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        title: const Text(
          'Scan Card',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Place your card on the back side of your phone',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hold the card steady near the NFC area while scanning.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final scale = 1 + (_controller.value * 0.08);

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBlue.withOpacity(0.08),
                          border: Border.all(
                            color: primaryBlue.withOpacity(0.28),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.nfc,
                            size: 90,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isScanning ? null : startScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: isScanning
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Scanning...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                    : const Text(
                  'Start Scan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}