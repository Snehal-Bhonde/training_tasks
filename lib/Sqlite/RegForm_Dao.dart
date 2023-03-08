/*
import 'dart:async';
import 'package:training_tasks/Sqlite/data_base.dart';
import 'package:training_tasks/Sqlite/RegModel.dart';

class RegFormDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Todo records
  Future<int> createRegForm(RegisterForm regForm) async {
    final db = await dbProvider.database;
    var result = db.insert(RegFormTABLE, regForm.toDatabaseJson());
    return result;
  }

  //Get All Todo items
  //Searches if query string was passed
  Future<List<RegisterForm>> getRegisterForms({required List<String> columns, required String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(RegFormTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(RegFormTABLE, columns: columns);
    }

    List<RegisterForm> registerForm = result.isNotEmpty
        ? result.map((item) => RegisterForm.fromDatabaseJson(item)).toList()
        : [];
    return registerForm;
  }

  //Update Todo record
  Future<int> updateRegisterForm(RegisterForm registerForm) async {
    final db = await dbProvider.database;

    var result = await db.update(RegFormTABLE, RegisterForm.toDatabaseJson(),
        where: "userId = ?", whereArgs: [registerForm.userId]);

    return result;
  }

  //Delete Todo records
  Future<int> deleteRegisterForm(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(RegFormTABLE, where: 'userId = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllRegForm() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      RegFormTABLE,
    );

    return result;
  }
}*/
