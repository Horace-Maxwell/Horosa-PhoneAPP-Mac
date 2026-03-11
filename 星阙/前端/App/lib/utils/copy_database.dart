import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:horosa/utils/log.dart';

Future<void> copyDatabase() async {
  var databases = [
    'countries.sqlite3',
    'states.sqlite3',
    'cities.sqlite3',
  ];

  var databasesPath = await getDatabasesPath();

  for (var db in databases) {
    var path = join(databasesPath, db);
    var exists = await databaseExists(path);

    if (!exists) {
      Log.t("Copying $db from assets");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "database", db));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      Log.t("Database $db already exists");
    }
  }

  Log.t("All databases copied");
}

Future<List<Map<String, dynamic>>> getCountries() async {
  var db = await openDatabase(join(await getDatabasesPath(), 'countries.sqlite3'));
  var result = await db.query('countries');
  await db.close();
  return result;
}

// Example function to fetch states based on country ID
Future<List<Map<String, dynamic>>> getStatesByCountryId(int countryId) async {
  var db = await openDatabase(join(await getDatabasesPath(), 'states.sqlite3'));
  var result = await db.query('states', where: 'country_id = ?', whereArgs: [countryId]);
  await db.close();
  return result;
}

// Example function to fetch cities based on state ID
Future<List<Map<String, dynamic>>> getCitiesByStateId(int stateId) async {
  var db = await openDatabase(join(await getDatabasesPath(), 'cities.sqlite3'));
  var result = await db.query('cities', where: 'state_id = ?', whereArgs: [stateId]);
  await db.close();
  return result;
}

Future<List<Map<String, dynamic>>> getCitiesByCountryId(int countryId) async {
  var db = await openDatabase(join(await getDatabasesPath(), 'cities.sqlite3'));
  var result = await db.query('cities', where: 'country_id = ?', whereArgs: [countryId]);
  await db.close();
  return result;
}