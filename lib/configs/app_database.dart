import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String dbName = "db.local";
String dbPath = "";
int version = 1;

Future<void> initiateDatabase() async {
  dbPath = join(await getDatabasesPath(), dbName);
  var database = await openDatabase(
    dbPath,
    version: version
  );

  String recipe = "CREATE TABLE IF NOT EXISTS recipes (id TEXT PRIMARY KEY, datasource TEXT, name TEXT, type TEXT, source TEXT, imagePath TEXT, dateInsert TEXT)";
  await database.execute(recipe);
}

Future<void> dropDatabase() async {
  dbPath = join(await getDatabasesPath(), dbName);

  var database = await openDatabase(
    dbPath,
    version: version
  );

  database.execute("DROP TABLE IF EXISTS recipes");

  initiateDatabase();
}