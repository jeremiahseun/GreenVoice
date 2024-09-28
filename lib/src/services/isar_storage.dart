import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;

class IsarStorageService {
  static late Isar isar;

  static Future<void> initialize() async {
    try {
      final dir = await path.getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [UserModelSchema],
        directory: dir.path,
      );
    } catch (e, stackTrace) {
      print('Error initializing Isar: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<UserModel?> readUserDB() async {
    final userDB = await isar.userModels.count();
    if (userDB == 0) return null;
    final user = await isar.userModels.get(1);
    return user;
  }

  Future<void> writeUserDB(UserModel user) async {
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  Future<void> clearDB() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
