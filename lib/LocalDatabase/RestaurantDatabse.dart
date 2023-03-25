import 'dart:io';
import 'dart:ui';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Restaurant {
  final int? id;
  final String title;
  final int branchId;
  final double latitude;
  final double longitude;
  final String image;

  Restaurant(
      {this.id,
      required this.title,
      required this.branchId,
      required this.latitude,
      required this.longitude,
      required this.image});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        title: json['title'],
        branchId: json['branch_id'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        image: json['image']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'branch_id': branchId,
      'latitude': latitude,
      'longitude': longitude,
      'image': image
    };
  }
}

class RestaurantDB {
  RestaurantDB._privateConstructor();

  static final RestaurantDB instance = RestaurantDB._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    return _database ?? await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'restaurant.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants(
        id INTEGER PRIMARY KEY,
        title TEXT,
        branch_id INTEGER,
        latitude REAL,
        longitude REAL,
        image TEXT
      )
    ''');
  }

  Future<bool> isTableEmpty() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> contents = await db.query('restaurants');
    return contents.isEmpty;
  }

  Future<List<Restaurant>> getRestaurantsInRange(double lat, double lng) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> restaurants =
        await db.rawQuery('''SELECT * FROM restaurants WHERE latitude BETWEEN ${lat-0.5} AND ${lat+0.5}''');

    List<Restaurant> categoryList = restaurants.isNotEmpty
        ? restaurants
        .where((r) => lng-0.5 <= r['longitude'] && r['longitude'] <= lng+0.5 )
        .map((r) => Restaurant.fromJson(r)).toList()
        : [];
    return categoryList;
  }

  Future<void> insertAll(List<Map<String, dynamic>> restaurants) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    for (var restaurant in restaurants) {
      batch.insert('restaurants', restaurant);
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteAll() async {
    Database db = await instance.database;
    await db.delete('restaurants');
  }

}
