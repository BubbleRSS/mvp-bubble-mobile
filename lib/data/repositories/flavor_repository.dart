import 'package:bubble_mobile/data/database_provider.dart';
import 'package:bubble_mobile/data/models/flavor.dart';
import 'package:sqflite/sqflite.dart';

class FlavorRepository {
  Future<List<Flavor>> getFlavors() async {
    final db = await DatabaseProvider().database;
    return await db
        .query('Flavor')
        .then((value) => value.map((e) => Flavor.fromMap(e)).toList());
  }

  Future<Flavor> getFlavorById(int id) async {
    final db = await DatabaseProvider().database;
    return await db.query('Flavor',
        where: 'id = ?',
        whereArgs: [id]).then((value) => Flavor.fromMap(value.first));
  }

  Future<void> insertFlavor(Flavor flavor) async {
    final db = await DatabaseProvider().database;
    await db.insert('Flavor', flavor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateFlavor(Flavor flavor) async {
    final db = await DatabaseProvider().database;
    await db.update('Flavor', flavor.toMap(),
        where: 'id = ?', whereArgs: [flavor.id]);
  }

  Future<void> deleteFlavor(int id) async {
    final db = await DatabaseProvider().database;
    await db.delete('Flavor', where: 'id = ?', whereArgs: [id]);
  }
}
