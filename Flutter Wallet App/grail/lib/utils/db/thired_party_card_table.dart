import 'package:sqflite/sqflite.dart';

import '../sqlite_strings.dart';

class ThiredPartyTable {
  static Future<void> createTable(Database db) async {
    return await db.execute(
      'CREATE TABLE ${SQLiteStrings.thiredPartyCardTable}'
      '(cardId text PRIMARY KEY,cardCode TEXT,cardName TEXT,color TEXT,date TEXT,userId TEXT)',
    );
  }

  static Future<void> dropTable(Database db) async {
    return await db
        .execute("drop table IF EXISTS ${SQLiteStrings.thiredPartyCardTable}");
  }
}
