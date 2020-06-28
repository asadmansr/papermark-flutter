import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "papermark.db";
  static final _databaseVersion = 1;

  static final bookTable = 'book_table';
  static final bookId = '_id';
  static final bookTitle = 'title';
  static final bookTotalCount = 'count';

  static final progressTable = 'progress_table';
  static final progressId = '_id';
  static final progressBook = 'book';
  static final progressPageCount = 'page';
  static final progressNote = 'note';
  static final progressMood = 'mood';
  static final progressDate = "date";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();


  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $bookTable (
            $bookId INTEGER PRIMARY KEY,
            $bookTitle TEXT NOT NULL,
            $bookTotalCount INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $progressTable (
            $progressId INTEGER PRIMARY KEY,
            $progressBook INTEGER NOT NULL,
            $progressPageCount INTEGER NOT NULL,
            $progressNote TEXT NOT NULL,
            $progressMood TEXT NOT NULL,
            $progressDate TEXT NOT NULL
          )
          ''');
  }

  /// Insert
  Future<int> insertBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(bookTable, row);
  }

  Future<int> insertProgress(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(progressTable, row);
  }

  /// Query
  Future<List<Map<String, dynamic>>> queryBook() async {
    Database db = await instance.database;
    return await db.query(bookTable);
  }

  Future<List<Map<String, dynamic>>> queryProgress() async {
    Database db = await instance.database;
    return await db.query(progressTable);
  }

  Future<List<Map<String, dynamic>>> queryProgressByBook(int id) async {
    Database db = await instance.database;
    return await db.query(progressTable, where: '$progressBook = ?', whereArgs: [id]);
  }

  Future<int> queryBookCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $bookTable'));
  }

  Future<int> queryProgressCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $progressTable'));
  }

  /// Update
  Future<int> updateBook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[bookId];
    return await db.update(bookTable, row, where: '$bookId = ?', whereArgs: [id]);
  }

  Future<int> updateProgress(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[progressId];
    return await db.update(progressTable, row, where: '$progressId = ?', whereArgs: [id]);
  }

  /// Delete
  Future<int> deleteBook(int id) async {
    Database db = await instance.database;
    return await db.delete(bookTable, where: '$bookId = ?', whereArgs: [id]);
  }

  Future<int> deleteProgress(int id) async {
    Database db = await instance.database;
    return await db.delete(progressTable, where: '$progressId = ?', whereArgs: [id]);
  }

  Future<int> deleteAllProgress(int id) async {
    Database db = await instance.database;
    return await db.delete(progressTable, where: '$progressBook = ?', whereArgs: [id]);
  }
}