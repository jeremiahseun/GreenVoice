import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  static const String _userBox = 'userBox';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>(_userBox);
  }

  Future<UserModel?> readUserDB() async {
    final box = Hive.box<UserModel>(_userBox);
    return box.isNotEmpty ? box.getAt(0) : null;
  }

  Future<void> writeUserDB(UserModel user) async {
    final box = Hive.box<UserModel>(_userBox);
    if (box.isEmpty) {
      await box.add(user);
    } else {
      await box.putAt(0, user);
    }
  }

  Future<void> clearDB() async {
    final box = Hive.box<UserModel>(_userBox);
    await box.clear();
  }
}
