import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  
  Future createDatabase() async {
    //
    if (_database != null) {
      return _database;
    }
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "demo5.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
      return await database.execute('''
              create table records(id integer primary key autoincrement, date text, name text, contact text,start_time text,
              end_time text, duration integer, total_cost real, paid real, due real)
              
              ''');
    });
  }

  Future insert(date, fullName, contact, startTime, endTime, duration,
      totalCost, paidAmount, dueAmount) async {
    await createDatabase();
    var map = {
      "date": date,
      "name": "$fullName",
      "contact": "$contact",
      "start_time": "$startTime",
      "end_time": "$endTime",
      "duration": "$duration",
      "total_cost": "$totalCost",
      "paid": "$paidAmount",
      "due": "$dueAmount",
    };
    await _database!.insert("records", map);
  }

  Future<List<Map<dynamic, dynamic>>> showAll() async {
    await createDatabase();
    List<Map> list = await _database!.query("records");

    return list;
  }

  Future delete(int id) async {
    try {
      await createDatabase();
      print(
          await _database!.delete("records", where: 'id = ?', whereArgs: [id]));
    } catch (Exception) {}
  }

   Future<List<Map<dynamic, dynamic>>> showSelectedName(String name) async {
    await createDatabase();
    List<Map> list = await _database!.query("records", where: 'name = ?', whereArgs: [name]);
    return list;
  }

   Future<List<Map<dynamic, dynamic>>> showSelectedContact(String contact) async {
    await createDatabase();
    List<Map> list = await _database!.query("records", where: 'contact = ?', whereArgs: [contact]);
    return list;

  }

  Future<List<Map<dynamic, dynamic>>> showUnPaid() async {
    await createDatabase();
    List<Map> list = await _database!.query("records", where: 'due != 0');
    return list;

  }

  Future updateDatabase(Map<String,Object?> data) async{
    await createDatabase();
    
    _database?.update("records",data, where: "id = ?", whereArgs: [data["id"]]);
  }
}
