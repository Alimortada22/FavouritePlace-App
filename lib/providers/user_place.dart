import 'dart:io';

import 'package:favourite_placess/model/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getdatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlaceNotifere extends StateNotifier<List<Places>> {
  UserPlaceNotifere() : super(const []);
  Future<void> loaddatabse() async {
    final db = await _getdatabase();
    final data = await db.query('user_places');
   final places= data.map((row) => Places(
      id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        placelocation: PlaceHolderLocation(
            lattitude: row['lat'] as double,
            lontitude: row['lng'] as double,
            address: row['address'] as String))).toList();
            state=places;
  }

  void addplace(String title, File image, PlaceHolderLocation location) async {
    final appdir = await syspath.getApplicationDocumentsDirectory();
    final imagename = path.basename(image.path);
    final copyedimage = await image.copy('${appdir.path}/$imagename');
    final newplace =
        Places(title: title, image: copyedimage, placelocation: location);
    final db = await _getdatabase();
    db.insert('user_places', {
      'id': newplace.id,
      'title': newplace.title,
      'image': newplace.image.path,
      'lat': newplace.placelocation.lattitude,
      'lng': newplace.placelocation.lontitude,
      'address': newplace.placelocation.address
    });

    state = [newplace, ...state];
  }
}

final userplacenotifier =
    StateNotifierProvider<UserPlaceNotifere, List<Places>>(
        (ref) => UserPlaceNotifere());
