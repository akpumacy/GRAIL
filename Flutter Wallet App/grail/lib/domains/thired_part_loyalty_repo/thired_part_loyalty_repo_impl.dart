
import 'package:grail/domains/thired_part_loyalty_repo/thired_part_loyalty_repo.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';
import '../../model/thired_party_card_model.dart';
import '../../utils/sqlite_strings.dart';

class ThiredPartyAndLoyalityCardRepoImpl
    implements ThiredPartyAndLoyalityCardRepo {
  @override
  Future saveCard({required GiftAndLoyaltyCard giftAndLoyaltyCard}) async {
    final db = await database;
    isCardAlreadyExists(
            id: giftAndLoyaltyCard.cardId,
            tableName: SQLiteStrings.thiredPartyCardTable)
        .then((value) async {
      if (value) {
        await updateCard(
            cardId: giftAndLoyaltyCard.cardId,
            giftAndLoyaltyCard: giftAndLoyaltyCard,
            tableName: SQLiteStrings.thiredPartyCardTable);
        kPrint("Already Downloaded emoji");
      } else {
        await db!.insert(
          SQLiteStrings.thiredPartyCardTable,
          giftAndLoyaltyCard.toSQLiteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        kPrint("File save to SQLite");
      }
    });
  }

  Future<bool> updateCard({
    required GiftAndLoyaltyCard giftAndLoyaltyCard,
    required String cardId,
    required String tableName,
  }) async {
    final db = await database;
    await db!.update(tableName, giftAndLoyaltyCard.toSQLiteMap(),
        where: 'cardId =?', whereArgs: [cardId]);

    return true;
  }

  Future<bool> isCardAlreadyExists(
      {required String id, required String tableName}) async {
    final db = await database;
    List<Map<String, Object?>> resultList =
        await db!.rawQuery('select * from $tableName where cardId =?', [id]);
    if (resultList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<GiftAndLoyaltyCard>> getAllThiredPartyCards(
      {required String userId}) async {
    final db = await database;

    List<GiftAndLoyaltyCard> thiredPartCardList = [];
    List<Map<String, Object?>> resultList = await db!.rawQuery(
        'select * from ${SQLiteStrings.thiredPartyCardTable} where userId =?',
        [userId]);
    if (resultList.isNotEmpty) {
      Iterator<Map<String, dynamic>> mapIterator = resultList.iterator;
      while (mapIterator.moveNext()) {
        var e = mapIterator.current;
        GiftAndLoyaltyCard giftAndLoyaltyCard = GiftAndLoyaltyCard(
          cardCode: e["cardCode"],
          cardId: e["cardId"],
          cardName: e["cardName"],
          color: e["color"],
          date: e["date"],
          userId: e["userId"],
        );

        thiredPartCardList.add(giftAndLoyaltyCard);
      }
    } else {}
    return thiredPartCardList;
  }

  @override
  Future<List<GiftAndLoyaltyCard>> getAllLoyalityCards(
      {required String userId}) async {
    final db = await database;

    List<GiftAndLoyaltyCard> loyalityCardList = [];
    List<Map<String, Object?>> resultList = await db!.rawQuery(
        'select * from ${SQLiteStrings.loyalityCardTable} where userId =?',
        [userId]);
    if (resultList.isNotEmpty) {
      Iterator<Map<String, dynamic>> mapIterator = resultList.iterator;
      while (mapIterator.moveNext()) {
        var e = mapIterator.current;
        GiftAndLoyaltyCard giftAndLoyaltyCard = GiftAndLoyaltyCard(
          cardCode: e["cardCode"],
          cardId: e["cardId"],
          cardName: e["cardName"],
          color: e["color"],
          date: e["date"],
          userId: e["userId"],
        );

        loyalityCardList.add(giftAndLoyaltyCard);
      }
    } else {}
    return loyalityCardList;
  }

  @override
  Future saveLoyalityCard(
      {required GiftAndLoyaltyCard giftAndLoyaltyCard}) async {
    final db = await database;
    isCardAlreadyExists(
            id: giftAndLoyaltyCard.cardId,
            tableName: SQLiteStrings.loyalityCardTable)
        .then((value) async {
      if (value) {
        await updateCard(
            cardId: giftAndLoyaltyCard.cardId,
            giftAndLoyaltyCard: giftAndLoyaltyCard,
            tableName: SQLiteStrings.loyalityCardTable);
        kPrint("Already Downloaded emoji");
      } else {
        await db!.insert(
          SQLiteStrings.loyalityCardTable,
          giftAndLoyaltyCard.toSQLiteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        kPrint("File save to SQLite");
      }
    });
  }

  @override
  Future deleteThiredPartyCard({required String cardId}) async {
    final db = await database;
    db!.delete(SQLiteStrings.thiredPartyCardTable,
        where: "cardId =?", whereArgs: [cardId]);
    kPrint("File delete from SQLite");
  }

  @override
  Future deleteLoyalityCard({required String cardId}) async {
    final db = await database;
    db!.delete(SQLiteStrings.loyalityCardTable,
        where: "cardId =?", whereArgs: [cardId]);
    kPrint("File delete from SQLite");
  }
}
