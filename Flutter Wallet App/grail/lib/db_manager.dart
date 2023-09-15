import 'package:grail/utils/db/loyality_card_table.dart';
import 'package:grail/utils/db/thired_party_card_table.dart';
import 'package:grail/utils/sqlite_strings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'main.dart';

class DbManager {
  static final DbManager _instance = DbManager();

  static DbManager instance() {
    return _instance;
  }

  static Future<bool> openDB() async {
    String userId = "tourist";
    // isLogined() ? getCurrentUserId() : 'tourist';
    // ConnectLogger.instance.openConnectLog();

    var databasePath = await getDatabasesPath();
    databasePath = "$databasePath/db/$userId";
    kPrint("database file path is => $databasePath userId:$userId");
    database = openDatabase(
      join(databasePath, "${SQLiteStrings.appDataBase}.db"),
      onCreate: (db, version) async {
        await _doCreateTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await ThiredPartyTable.dropTable(db);
        await LoyalityCardTable.dropTable(db);

        await _doCreateTable(db);
      },
      version: 76,
    );
    return true;
  }

  static _doCreateTable(Database db) async {
    await ThiredPartyTable.createTable(db);
    await LoyalityCardTable.createTable(db);
  }

  static Future<bool> closeDB(String userId) async {
    var tmp = await database;
    if (tmp != null) {
      if (tmp.path.endsWith('/$userId')) {
        tmp.close();
        tmp = null;
      }
    }
    return true;
  }
}
