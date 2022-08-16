import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      body TEXT,
      color TEXT,
      date_created DATE
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("simple_note_app.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> postNote(
      String title, String body, Color color, String date) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'body': body,
      'color': color.toString(),
      'date_created': date
    };
    return await db.insert('notes', data);
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SQLHelper.db();
    return db.query("notes");
  }

  static Future<int> editNotes(int id, String title, String body) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'body': body};
    return await db.update("notes", data, where: "id = $id");
  }

  static Future<int> deleteNotes(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('notes', where: "id = $id");
  }
}
