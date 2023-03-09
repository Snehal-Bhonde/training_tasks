/*
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
final RegFormTABLE = 'RegForm';
class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  late Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }
  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "ReactiveRegForm.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }
  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }
  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $RegFormTABLE ("
        "userId INTEGER PRIMARY KEY, "
        "firstName TEXT, "
        "lastName TEXT, "
        "mobNo INTEGER,"
        "email TEXT, "
        "dateTime TEXT "
        ")");
  }
}*/

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:training_tasks/Sqlite/RegModel.dart';



class DatabaseRepository {
  Database?_database;
  static final DatabaseRepository instance = DatabaseRepository
      ._init(); // our class will always have one instane only to make sure the database is only one
  DatabaseRepository._init();


  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("reg_formdb.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
create table ${AppConst.tableName} ( 
  ${AppConst.uid} integer primary key autoincrement, 
  ${AppConst.firstName} text not null,
   ${AppConst.lastName} text not null,
   ${AppConst.mobNo} integer not null,
   ${AppConst.email} text not null,
   ${AppConst.dateTime} text not null)
''');
  }

  Future<void> insert({required RegisterForm registerForm}) async {
    try {
      final db = await database;
      db.insert(AppConst.tableName, registerForm.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<RegisterForm>> getAllTodos() async {
    final db = await instance.database;

    final result = await db.query(AppConst.tableName);

    return result.map((json) => RegisterForm.fromJson(json)).toList();
  }

  Future<void> delete(int id) async {
    try {
      final db = await instance.database;
      await db.delete(
        AppConst.tableName,
        where: '${AppConst.uid} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> update(RegisterForm registerForm) async {
    try {
      final db = await instance.database;
      db.update(
        AppConst.tableName,
        registerForm.toMap(),
        where: '${AppConst.uid} = ?',
        whereArgs: [registerForm.userId],
      );
    } catch (e) {
      print("update failed");
      print(e.toString());
    }
  }

}
class AppConst {
  static const String uid = 'userId';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String mobNo = 'mobNo';
  static const String email = 'email';
  static const String dateTime = 'dateTime';
  static const String tableName = 'RegFormTable';
}