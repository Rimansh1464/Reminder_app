import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/modls.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper dbHelper = DBHelper._();


  String table = "reminders";
  Database? db;
  String databasepath = "";


  Future<Database?> initDB() async {
    String path = await getDatabasesPath();
    databasepath = join(path, "databases.db");

    db = await openDatabase(databasepath, version: 1,
        onCreate: (Database db, version) async {
          String query =
              "CREATE TABLE IF NOT EXISTS $table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT ,subtitle TEXT,time Text);";
          await db.execute(query);
        });
    String query =
        "CREATE TABLE IF NOT EXISTS $table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT ,subtitle TEXT,time Text);";
    await db!.execute(query);
    return db;
  }



  Future<void> insertData(
      {required String title, required String subtitle,required String time}) async {
    db= await initDB();

    String query = "INSERT INTO $table VALUES(?,?,?,?)";
    List args = [null, title, subtitle,time];
    print("Insert Record Successful Where id ==> ${title.length}");

    await db!.rawInsert(query,args);
  }
  Future<void> update(
      {required int id,required String time}) async {
    db= await initDB();

    String query = "UPDATE $table SET time=? WHERE id=?";
    List arg =[time,id];

    print("Insert Record Successful Where id ==>}");

    await db!.rawInsert(query,arg);
  }


Future<List<Reminders>> fetchhhhData() async {
  db = await initDB();

  String query = "SELECT * FROM $table";
  List<Map<String, dynamic>> data = await db!.rawQuery(query);

  List<Reminders> foodData = postDataModelFromJson(jsonEncode(data));

  print("object ==> ${data.length}");

  return foodData;
}


  deletData() async {
    db = await initDB();
    String query = "DROP TABLE $table ";
    await db!.execute(query).then((value) {
      // print("$table ==> Delete ");
    });
  }
  singlDelet({required id})async{
    db = await initDB();
    String query = "DELETE FROM $table WHERE id=$id";
    await db!.rawDelete(query);
  }
}
