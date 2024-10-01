import 'package:flutter/foundation.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';

import 'isar_storage.dart';
import 'storage_service.dart';
import 'web_service.dart';

class UserService {
  static final storageService = locator<StorageService>();
  static final isarStorageService = locator<IsarStorageService>();
  static Future<UserModel?> getSavedUser() async {
    String userId = '';
    String username = '';
    String userPicture = '';
    if (kIsWeb) {
      //* Web user reads from Web storage
      userId = WebService.readWebData(key: StorageKeys.userId) ?? '';
      username =
          WebService.readWebData(key: StorageKeys.username) ?? 'Web User';
      userPicture = WebService.readWebData(key: StorageKeys.userPicture) ?? '';
    } else {
      //* Mobile user reads from mobile storage
      userId =
          await storageService.readSecureData(key: StorageKeys.userId) ?? '';
      final isarData = await isarStorageService.readUserDB();
      userPicture = isarData?.photo ?? '';
      username = "${isarData?.firstName} ${isarData?.lastName}";
    }
    if (userId.isEmpty) {
      return null;
    }
    String firstName = '';
    String lastName = '';
    if (username.isNotEmpty) {
      firstName = username.split(" ").first;
      lastName = username.split(" ").last;
    } else {
      firstName = username;
    }
    return UserModel(
        uid: userId,
        photo: userPicture,
        firstName: firstName,
        lastName: lastName);
  }
}
