import 'package:flutter/material.dart';
import 'scan_card_screen.dart';
import 'add_card_screen.dart';
import 'camera_scan_screen.dart';
import 'card_list_screen.dart';
import 'login_screen.dart';
import '../services/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardOptionsScreen extends StatelessWidget {
  const CardOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF112D6B);
    const signupColor = Color(0xDD4277C1);
    const darkBlue = Color(0xFF0D1B4C);
    const lightBg = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: lightBg,

      // ✅ APP BAR
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        title: const SizedBox(),
        iconTheme: const IconThemeData(color: primaryBlue),

        // 🔙 BACK BUTTON (LOGOUT)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final googleAuthService = GoogleAuthService();
            await googleAuthService.signOut();

            if (!context.mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),

        // 👉 RIGHT SIDE ICONS
        actions: [
          // ✅ GOOGLE BADGE
          if (FirebaseAuth.instance.currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      final user = FirebaseAuth.instance.currentUser;

                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Text(user?.displayName ?? "User"),
                            Text(user?.email ?? ""),
                            const SizedBox(height: 15),

                            ElevatedButton(
                              onPressed: () async {
                                final googleAuthService = GoogleAuthService();
                                await googleAuthService.signOut();

                                if (!context.mounted) return;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },

                // 👇 THIS IS CHILD (IMPORTANT)
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF112D6B).withOpacity(0.1),
                  backgroundImage:
                      FirebaseAuth.instance.currentUser!.photoURL != null
                      ? NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                        )
                      : null,
                  child: FirebaseAuth.instance.currentUser!.photoURL == null
                      ? Text(
                          FirebaseAuth.instance.currentUser!.displayName != null
                              ? FirebaseAuth
                                    .instance
                                    .currentUser!
                                    .displayName![0]
                                    .toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Color(0xFF112D6B),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),

          // 📋 SAVED CARD LIST BUTTON
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CardListScreen()),
              );
            },
          ),
        ],
      ),

      // ✅ BODY
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            const Text(
              'Choose how you want to add',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: darkBlue,
              ),
            ),
            const Text(
              'your Card',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 72, 92, 167),
              ),
            ),

            const SizedBox(height: 105),

            const Text(
              "Add your card effortlessly :)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(137, 2, 0, 0),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Scan via NFC, OCR camera, or enter details manually.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: darkBlue,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 30),

            // 🔵 SCAN PHYSICAL CARD
            _optionCard(
              context: context,
              title: 'Scan Physical Card',
              subtitle: 'Place your card near the back of your phone',
              icon: Icons.nfc,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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

                            const SizedBox(height: 10),

                            ListTile(
                              leading: const Icon(
                                Icons.nfc,
                                color: primaryBlue,
                              ),
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

                            ListTile(
                              leading: const Icon(
                                Icons.camera_alt,
                                color: primaryBlue,
                              ),
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

            const SizedBox(height: 28),

            // 🟣 ADD VIRTUAL CARD
            _optionCard(
              context: context,
              title: 'Add Virtual Card',
              subtitle: 'Enter card details manually',
              icon: Icons.add_card_rounded,
              color: signupColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCardScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 OPTION CARD WIDGET
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
                : [const Color(0xFF0D1B4C), const Color(0xFF112D6B)],
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
              child: Icon(icon, color: Colors.white, size: 30),
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
                    ),
                  ),
                ],
              ),
            ),
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
