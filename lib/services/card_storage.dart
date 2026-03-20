import '../models/card_model.dart';

class CardStorage {
  static List<CardModel> cards = [];

  static void addCard(CardModel card) {
    cards.add(card);
  }

  static List<CardModel> getCards() {
    return cards;
  }
}