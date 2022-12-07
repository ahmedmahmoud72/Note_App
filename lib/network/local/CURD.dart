import 'package:ieee_note_app/models/models.dart';
import 'package:ieee_note_app/network/local/database_helper.dart';
import 'package:ieee_note_app/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class CURD {
  Database? db;

  CURD() {
    init();
  }

  init() async {
    db = await DbHelper.helper.getInstance();
  }

  Future<int> insert(Note note) async {
    return await db!.insert(tableName, note.toMap());
  }

  Future<int> update(Note note) {
    return db!.update(tableName, note.toMap(),
        where: '$colId = ?', whereArgs: [note.noteId]);
  }

  Future<int> delete(int? noteId) async {
    return await db!
        .delete(tableName, where: '$colId = ?', whereArgs: [noteId]);
  }

  query() async {
    Database db = await DbHelper.helper.getInstance();
    List<Map<String, dynamic>> data =
        await db.query(tableName, orderBy: '$colDate desc');
    List<Note> notes = data.map((e) => Note.fromNote(e)).toList();
    return notes;
  }
}
