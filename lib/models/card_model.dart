class CardModel {
  final String number;
  final String name;
  final String expiry;
  final String type; // NFC | CAMERA | VIRTUAL

  CardModel({
    required this.number,
    required this.name,
    required this.expiry,
    required this.type,
  });
}