//memo(小文字)がテーブル名に設定されているので、訂正する必要がある
//myref2(myref.dbをコピーしたもの)を使用
//一時的にimageカラムを削除
//import 'dart:html';
import 'package:blobs/blobs.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import './database_myref.dart';

Future<Database> get database async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, 'assets/myref3.db');
  var exists = await databaseExists(path);

  if (!exists) {
    try {
      await io.Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    var data = await rootBundle.load(join('assets', 'myref3.db'));
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await io.File(path).writeAsBytes(bytes, flush: true);
  }
  //import 'dart:html';をコメントするとエラーが消える
  return await openDatabase(path);
}

//クラス名Material テーブル名material
//クラス
class Material_db {
  final int id;
  //final String id;
  final String name;
  final String kana;
  final String category;
  final int exday;
  final Blob image;

  Material_db({
    required this.id,
    required this.name,
    required this.kana,
    required this.category,
    required this.exday,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'kana': this.kana,
      'category': this.category,
      'exday': this.exday,
      'image': this.image,
    };
  }

  @override
  String toString() {
    return 'material{id: $id, name: $name, kana:$kana,category:$category,exday:$exday,image:$image)';
  }

  /*static Future<Database> get database async {
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'myref3.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE material(id INTEGER PRIMARY KEY AUTOINCREMENT,name STRING,kana STRING,category STRING,exday INTEGER)",
        );
      },
      version: 1,
    );
    return _database;
  }*/

  //image: $image}';
  //挿入
  static Future<void> insertMaterial(Material_db material) async {
    final Database db = await database;
    await db.insert(
      'material',
      material.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //取得
  /*static Future<List<Material_db>> getMaterial() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('material');
    return List.generate(maps.length, (i) {
      return Material_db(
        id: maps[i]['id'],
        name: maps[i]['name'],
        kana: maps[i]['kana'],
        category: maps[i]['result'],
        exday: maps[i]['exday'],
      );
    });
  }*/

  //exdayだけを取得
  static Future<List<Material_db>> getExday() async {
    final Database db = await database;
    //Prefer const over final for declarationsが出たのでfinalではなくconstを使用
    const String sql = 'SELECT id,exday FROM material';
    final List<Map<String, dynamic>> result = await db.rawQuery(sql);
    //return result;
    return List.generate(result.length, (i) {
      return Material_db(
        id: result[i]['id'],
        name: result[i]['name'],
        kana: result[i]['kana'],
        category: result[i]['result'],
        //int.parse
        exday: result[i]['exday'],
        image: result[i]['image'],
      );
    });
  }

  //var _exday = DataCell(exday);
}
