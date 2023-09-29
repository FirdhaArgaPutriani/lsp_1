import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lsp_1/models/income.dart';
import 'package:lsp_1/models/outcome.dart';
import 'package:lsp_1/models/users.dart';

class DatabaseHelper {
  final databaseName = "lsp.db";

  // tabel income
  String incomeTable =
      "CREATE TABLE income (incomeId INTEGER PRIMARY KEY AUTOINCREMENT, keterangan TEXT NOT NULL, nominal REAL NOT NULL, tanggal TEXT)";

  // tabel outcome
  String outcomeTable =
      "CREATE TABLE outcome (outcomeId INTEGER PRIMARY KEY AUTOINCREMENT, keterangan TEXT NOT NULL, nominal REAL NOT NULL, tanggal TEXT)";

  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  //We are done in this section

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(incomeTable);
      await db.execute(outcomeTable);
    });
  }

  //Now we create login and sign up method
  //as we create sqlite other functionality in our previous video

  //IF you didn't watch my previous videos, check part 1 and part 2

  //Login Method

  Future<bool> login(Users user) async {
    final Database db = await initDB();

    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  //CRUD Income Methods

  //Create Income
  Future<int> createIncome(IncomeModel income) async {
    final Database db = await initDB();
    return db.insert('income', income.toMap());
  }

  //Get Income
  Future<List<IncomeModel>> getIncome() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('income');
    return result.map((e) => IncomeModel.fromMap(e)).toList();
  }

  //Delete Income
  Future<int> deleteIncome(int id) async {
    final Database db = await initDB();
    return db.delete('income', where: 'incomeId = ?', whereArgs: [id]);
  }

  //Update Income
  Future<int> updateIncome(keterangan, nominal, tanggal, incomeId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update income set keterangan = ?, nominal = ?, tanggal = ? where incomeId = ?',
        [keterangan, nominal, tanggal, incomeId]);
  }

  //CRUD Outcome Methods

  //Create Outcome
  Future<int> createOutcome(OutcomeModel note) async {
    final Database db = await initDB();
    return db.insert('outcome', note.toMap());
  }

  //Get Outcome
  Future<List<OutcomeModel>> getOutcome() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('outcome');
    return result.map((e) => OutcomeModel.fromMap(e)).toList();
  }

  //Delete Outcome
  Future<int> deleteOutcome(int id) async {
    final Database db = await initDB();
    return db.delete('outcome', where: 'outcomeId = ?', whereArgs: [id]);
  }

  //Update Outcome
  Future<int> updateOutcome(keterangan, nominal, tanggal, outcomeId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update outcome set noteTitle = ?, noteContent = ? where outcomeId = ?',
        [keterangan, nominal, tanggal, outcomeId]);
  }
}
