import 'package:flutter/material.dart';
import '../services/card_storage.dart';
import '../models/card_model.dart';

class CardListScreen extends StatelessWidget {
  const CardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = CardStorage.getCards();

    const primaryBlue = Color(0xFF112D6B);
    const lightBg = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: lightBg,
        elevation: 0,
        title: const Text(
          "Saved Cards",
          style: TextStyle(color: primaryBlue),
        ),
        iconTheme: const IconThemeData(color: primaryBlue),
      ),
      body: cards.isEmpty
          ? const Center(child: Text("No cards added yet"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _cardTile(card);
        },
      ),
    );
  }

  Widget _cardTile(CardModel card) {
    Color typeColor;

    switch (card.type) {
      case "NFC":
        typeColor = Colors.green;
        break;
      case "CAMERA":
        typeColor = Colors.orange;
        break;
      default:
        typeColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1B4C), Color(0xFF112D6B)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.name,
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                card.expiry,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              card.type,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}