import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class RentDatabaseHelper {
  static const _databaseName = "renteditemList.db";
  static const _databaseVersion = 1;

  static const table = 'renteditems';

  static const heading = 'heading';
  static const description = 'description';
  static const prices = 'prices';
  static const personName = 'personName';
  static const phoneNumber = 'phoneNumber';
  static const noOfDays = 'noOfDays';

  late Database _db;
  // this opens the database (and creates it if it doesn't exist)
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
            $heading TEXT NOT NULL,
            $description TEXT NOT NULL,
            $prices TEXT NOT NULL,
            $personName TEXT PRIMARY KEY,
            $phoneNumber TEXT NOT NULL,
            $noOfDays TEXT NOT NULL
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
  Future<int> update(String itemHeading,String itemDescription,String itemPrice,String itemPersonName,String itemPhoneNumber,String itemNoOfDays) async {
    return await _db.rawUpdate(
        '''UPDATE $table 
      SET $description = ?, $prices = ?,$heading = ?,$phoneNumber = ?,$noOfDays = ?
      WHERE $personName = ?;''',
        [itemDescription,itemPrice,itemHeading,itemPhoneNumber,itemNoOfDays,itemPersonName,]
    );

  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String personNames) async {
    return await _db.delete(
      table,
      where: '$personName = ?',
      whereArgs: [personNames],
    );
  }
}