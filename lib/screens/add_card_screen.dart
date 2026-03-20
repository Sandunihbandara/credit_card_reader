import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_storage.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    nameController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  void formatExpiry(String value) {
    String text = value.replaceAll('/', '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    if (text.length > 2) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    expiryController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void saveCard() {
    if (!_formKey.currentState!.validate()) return;

    CardStorage.addCard(
      CardModel(
        number: cardNumberController.text,
        name: nameController.text,
        expiry: expiryController.text,
        type: "VIRTUAL",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card saved successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF112D6B);
    const signupColor = Color(0xDD4277C1);
    const lightBg = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        title: const Text(
          "Add Virtual Card",
          style: TextStyle(color: primaryBlue),
        ),
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // Card preview UI
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B4C), Color(0xFF112D6B)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CARD NUMBER",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cardNumberController.text.isEmpty
                        ? "XXXX XXXX XXXX XXXX"
                        : cardNumberController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nameController.text.isEmpty
                            ? "CARD HOLDER"
                            : nameController.text.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        expiryController.text.isEmpty
                            ? "MM/YY"
                            : expiryController.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        controller: cardNumberController,
                        hint: "Card Number",
                        icon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.length < 16) {
                            return "Enter valid card number";
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 15),

                      _buildField(
                        controller: nameController,
                        hint: "Card Holder Name",
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller: expiryController,
                              hint: "MM/YY",
                              icon: Icons.date_range,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.length < 5) {
                                  return "Invalid";
                                }
                                return null;
                              },
                              onChanged: formatExpiry,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildField(
                              controller: cvvController,
                              hint: "CVV",
                              icon: Icons.lock,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.length < 3) {
                                  return "Invalid";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: saveCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: signupColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "Save Card",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF112D6B)),
        filled: true,
        fillColor: const Color(0xFFF6F8FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
