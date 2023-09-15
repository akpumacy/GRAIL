import 'package:intl/intl.dart';

import '../view/helper_function/enums.dart';

String currentDate = DateFormat(DateType.yearMonthDay).format(DateTime.now());

class GiftAndLoyaltyCard {
  String cardId;
  String cardCode;
  String cardName;
  String color;
  String date;
  String userId;

  GiftAndLoyaltyCard(
      {required this.cardId,
      required this.cardCode,
      required this.cardName,
      required this.color,
      required this.userId,
      required this.date});

  Map<String, dynamic> toSQLiteMap() {
    return {
      "cardId": cardId,
      "cardCode": cardCode,
      "cardName": cardName,
      "color": color,
      "userId": userId,
      "date": date,
    };
  }
}
