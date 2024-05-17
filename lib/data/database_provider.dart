import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _databaseName = 'bubble_database.db';
  static const _databaseVersion = 1;

  DatabaseProvider._();
  static final DatabaseProvider instance = DatabaseProvider._();

  factory DatabaseProvider() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Flavor (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        icon TEXT,
        color TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Tea (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        flavor_id INTEGER,
        rss_link TEXT,
        title TEXT,
        FOREIGN KEY (flavor_id) REFERENCES Flavor(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Bubble (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        tea_id INTEGER,
        header TEXT,
        description TEXT,
        image_source TEXT,
        datetime TEXT,
        FOREIGN KEY (tea_id) REFERENCES Tea(id)
      )
    ''');
  }

   Future<void> exportDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, _databaseName);

      final directory = await getApplicationDocumentsDirectory();
      final exportPath = join(directory.path, _databaseName);

      final dbFile = File(path);
      final exportFile = File(exportPath);

      if (await dbFile.exists()) {
        await exportFile.writeAsBytes(await dbFile.readAsBytes());

        Share.shareXFiles([XFile(exportPath)], text: 'Bubble database export');
      } else {
        print('Database file does not exist.');
      }
    } catch (e) {
      print('Error exporting database: $e');
    }
  }
}
