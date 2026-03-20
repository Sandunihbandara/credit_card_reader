import 'package:flutter/material.dart';
import 'scan_card_screen.dart';
import 'add_card_screen.dart';
import 'camera_scan_screen.dart';
import 'card_list_screen.dart';


class CardOptionsScreen extends StatelessWidget {
  const CardOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF112D6B);
    const signupColor= Color(0xDD4277C1);
    const darkBlue = Color(0xFF0D1B4C);
    const lightBg = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        title: const SizedBox(),
        iconTheme: const IconThemeData(color: primaryBlue),

        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CardListScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(

        padding: const EdgeInsets.all(22),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Choose how you want to add',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: darkBlue,
              ),
            ),
            const Text(
              'your Card',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "  Add your card effortlessly  :)",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const Text(
              "scan via NFC, OCR camera, or enter details manually.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 80),

            _optionCard(
              context: context,
              title: 'Scan Physical Card',
              subtitle: 'Place your card near the back of your phone',
              icon: Icons.nfc,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Choose Scan Method",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              leading: const Icon(Icons.nfc, color: Color(0xFF112D6B)),
                              title: const Text("Scan with NFC"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ScanCardScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              leading: const Icon(Icons.camera_alt, color: Color(0xFF112D6B)),
                              title: const Text("Scan with Camera"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CameraScanScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 28,),
            _optionCard(
              context: context,
              title: 'Add Virtual Card',
              color: signupColor,
              subtitle: 'Enter card details manually',
              icon: Icons.add_card_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddCardScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color != null
                ? [color.withOpacity(0.9), color]
                : [Color(0xFF0D1B4C), Color(0xFF112D6B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}