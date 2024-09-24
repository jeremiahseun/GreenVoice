import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  //? CRUD OPERATIONS FOR SHARED PREFERENCES
  //* READING DATA
  Future<int?> readIntData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double?> readDoubleData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<String?> readStringData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool?> readBoolData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  //* WRITING DATA
  Future<void> writeSharedPrefData(
      {required String key, required dynamic value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value.toInt());
    } else if (value is double) {
      await prefs.setDouble(key, value.toDouble());
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value.toString());
    }
  }

  //* DELETING DATA SHARED PREFERENCE
  Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  //? CRUD OPERATIONS FOR FLUTTER SECURE STORAGE

  //* WRITING SECURE DATA
  Future<void> writeSecureData(
      {required String key, required dynamic value}) async {
    await storage.write(key: key, value: value);
  }

  //* DELETING SECURE DATA
  Future<void> clearAllSecure() async {
    await storage.deleteAll();
  }

  //* READING SECURE DATA
  Future<String?> readSecureData({required String key}) async {
    final data = await storage.read(key: key);

    return data;
  }
}
