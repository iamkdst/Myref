//myref2(myref.dbをコピーしたもの)を使用
//dart:htmlを消したらエラーが消えた　dart:htmlが必要でないところは書くべきじゃない
import 'dart:io' as io;
//import 'package:app_grid17/database_material.dart';
import 'package:app_grid19/database_material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
//import './database_material.dart';

//事前に作ったDBをコピーして使う
Future<Database> get database async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, 'assets/myref3.db');
  // データベースが存在するかどうかを確認する
  var exists = await databaseExists(path);
  if (!exists) {
    // 親ディレクトリが存在することを確認する
    try {
      await io.Directory(dirname(path)).create(recursive: true);
    } catch (_) {}
    // アセットからコピー
    var data = await rootBundle.load(join('assets', 'myref3.db'));
    List<int> bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    // 書き込まれたバイトを書き込み、フラッシュする
    await io.File(path).writeAsBytes(bytes, flush: true);
  }
  //DBファイルを開く
  return await openDatabase(path);
}

//クラス
class Refri {
  final int id;
  final int count;
  final String date;

  Refri({
    required this.id,
    required this.count,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count': count,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'refri{id: $id, count:$count,date:$date}';
  }

  static Future<Database> get database async {
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'myref3.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE refri(id INTEGER PRIMARY KEY AUTOINCREMENT, count INTEGER,date STRING)",
        );
      },
      version: 1,
    );
    return _database;
  }

  //これ以降、memoをどうするか　databaseエラー getDBで本当にいいのだろうか
  //挿入
  static Future<void> insertMemo(Refri refri) async {
    final Database db = await database;
    await db.insert(
      'refri',
      refri.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //取得
  static Future<List<Refri>> getMemos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('refri');
    return List.generate(maps.length, (i) {
      return Refri(
        id: maps[i]['id'],
        count: maps[i]['count'],
        date: maps[i]['date'],
      );
    });
  }

  static Future<void> updateExpiry(Refri refri) async {
    final Database db = await database;
    const String sql = 'SELECT date FROM refri';
    const String sql2 = 'SELECT exday FROM material';
    //var time = ;
    //賞味期限の計算
    final _time = DateFormat('yyyy-MM-dd')
        .parse(sql)
        .add(Duration(days: int.parse(sql2)));
    await db.update(
      'refri',
      refri.toMap(),
      where: "id = ?",
      whereArgs: [refri.date],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    /*String sql3 = Refri{
        id: id;
        count:count;
        date: time.toString();
      }*/
    //String sql3 =date =time.toString();
  }

  static Future<void> insertExpiry(Refri refri) async {
    final Database db = await database;
    //var update_expiry = await updateExpiry(Refri refri);
    //yield update_expiry;
    await db.insert(
      'refri',
      refri.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //date取得とdb更新
  static Future<List<Refri>> getDate() async {
    //Prefer const over final for declarationsが出たのでfinalではなくconstを使用
    final Database db = await database;
    var update_expiry = await updateExpiry();
    yield update_expiry;
    const String sql3 = 'SELECT date FROM refri';
    final List<Map<String, dynamic>> result = await db.rawQuery(sql3);
    //var result = await db.rawQuery(time.toString());
    return List.generate(result.length, (i) {
      return Refri(
        id: result[i]['id'],
        count: result[i]['count'],
        date: result[i]['date'],
      );
    });
  }
  //update後getdate

  //同時に

  //更新
  static Future<void> updateMemo(Refri refri) async {
    // Get a reference to the database.
    final db = await database;
    await db.update(
      'refri',
      refri.toMap(),
      where: "id = ?",
      whereArgs: [refri.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  //削除
  static Future<void> deleteMemo(int id) async {
    final db = await database;
    await db.delete(
      'refri',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
