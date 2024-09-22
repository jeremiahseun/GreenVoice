import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarStorageService {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        UserModelSchema,
      ],
      directory: dir.path,
    );
  }

  Future<UserModel?> readUserDB() async {
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
