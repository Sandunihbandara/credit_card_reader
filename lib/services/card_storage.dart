import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_model.dart';

class CardStorage {
  static const String key = 'cards';

  static Future<List<CardModel>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];

    return list.map((e) => CardModel.fromMap(jsonDecode(e))).toList();
  }

  static Future<void> saveCard(CardModel card) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];

    list.add(jsonEncode(card.toMap()));
    await prefs.setStringList(key, list);
  }
}