import 'dart:async';

import 'package:blog_applicaton/databseModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';
class DatabaseClass {
  Future<Database> initializedDB()  async {

    String path = await getDatabasesPath();
    print(path);
    return openDatabase(
      join(path,'favorite.db'),
      version:1,
      onCreate: (Database db ,int version) async{
      await db.execute("CREATE TABLE favorite (id Text PRIMARY KEY, image TEXT NOT NULL,title TEXT NOT NULL)") ;
        },) ;
  }
  Future<int> insertFavorite(DatabaseModel blog) async {
    int result = 0;
    final Database db = await initializedDB();
      result = await db.insert('favorite' ,blog.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<DatabaseModel>> getBlogs() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('favorite');
    print("getting here");
    return queryResult.map((e) => DatabaseModel.fromMap(e)).toList();

  }

  Future<void> removeBlog(String id) async {
    final db = await initializedDB();
    await db.delete(
      'favorite',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}