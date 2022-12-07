import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../utils/constants.dart';

class DbHelper {
  DbHelper._instance();

  static final DbHelper helper = DbHelper._instance();

  Future<String> getMyDbPath() async {
    String dbPath = await getDatabasesPath();
    return join(dbPath, dbName);
  }

  Future<Database> getInstance() async {
    String myDbPath = await getMyDbPath();
    return await openDatabase(
      myDbPath,
      version: dbVersion,
      onCreate: (db, version) => _createDatabase(db),
      onUpgrade: (db, newDbVersion, oldDbVersion) => _updateDatabase(db),
    );
  }

  void _createDatabase(Database db) {
    String sql =
        "create table $tableName($colId integer primary key autoincrement, $colText text, $colDate text, $colUpdateDate text)";
    db.execute(sql);
    print(sql);
  }

  void _updateDatabase(Database db) {}
}
