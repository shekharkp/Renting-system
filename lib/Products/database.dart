
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "itemLists.db";
  static const _databaseVersion = 1;

  static const table = 'item1';

  static const heading = 'heading';
  static const description = 'description';
  static const price = 'price';

  late Database _db;
  // Creates database
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $heading TEXT PRIMARY KEY,
            $description TEXT NOT NULL,
            $price TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }


  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String itemHeading,String itemDescription,String itemPrice) async {
    return await _db.rawUpdate(
      '''UPDATE $table 
      SET $description = ?, $price = ?
      WHERE $heading = ?;''',
      [itemDescription,itemPrice,itemHeading]
    );

  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String headings) async {
    return await _db.delete(
      table,
      where: '$heading = ?',
      whereArgs: [headings],
    );
  }
}