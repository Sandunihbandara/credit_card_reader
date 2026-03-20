class CardModel {
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cardType;

  CardModel({
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
  });

  Map<String, dynamic> toMap() {
    return {
      'holderName': holderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardType': cardType,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      holderName: map['holderName'],
      cardNumber: map['cardNumber'],
      expiryDate: map['expiryDate'],
      cardType: map['cardType'],
    );
  }
}