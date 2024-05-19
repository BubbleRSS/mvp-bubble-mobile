import 'package:bubble_mobile/data/database_provider.dart';
import 'package:bubble_mobile/data/models/tea.dart';
import 'package:sqflite/sqflite.dart';

class TeaRepository {
  Future<List<Tea>> getTeasByFlavorId(int id) async {
    final db = await DatabaseProvider().database;
    return await db.query('Tea', where: 'flavor_id = ?', whereArgs: [id]).then(
        (value) => value.map((e) => Tea.fromMap(e)).toList());
  }

  Future<void> insertTea(Tea tea) async {
    final db = await DatabaseProvider().database;
    await db.insert('Tea', tea.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTea(Tea tea) async {
    final db = await DatabaseProvider().database;
    await db.update('Tea', tea.toMap(), where: 'id = ?', whereArgs: [tea.id]);
  }

  Future<void> deleteTea(int id) async {
    final db = await DatabaseProvider().database;
    await db.delete('Tea', where: 'id = ?', whereArgs: [id]);
  }
}
