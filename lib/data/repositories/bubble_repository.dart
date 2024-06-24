import 'package:bubble_mobile/data/database_provider.dart';
import 'package:bubble_mobile/data/models/bubble.dart';
import 'package:sqflite/sqflite.dart';

class BubbleRepository {
  Future<List<Bubble>> getBubbles() async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> maps = await db.query('Bubble');
    return List<Bubble>.from(maps.map((map) => Bubble.fromMap(map)));
  }

  Future<List<Bubble>> getBubblesByTeaId(int id) async {
    final db = await DatabaseProvider().database;
    return await db.query('Bubble', where: 'tea_id = ?', whereArgs: [id]).then(
        (value) => value.map((e) => Bubble.fromMap(e)).toList());
  }

  Future<void> insertBubble(Bubble bubble) async {
    final db = await DatabaseProvider().database;
    await db.insert('Bubble', bubble.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteBubble(int? id) async {
    final db = await DatabaseProvider().database;
    await db.delete('Bubble', where: 'id = ?', whereArgs: [id]);
  }
}
