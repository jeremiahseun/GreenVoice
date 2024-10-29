import 'package:flutter/foundation.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';

import 'hive_storage.dart';
import 'storage_service.dart';
import 'web_service.dart';

class UserService {
  static final storageService = locator<StorageService>();
  static final hiveStorageService = locator<HiveStorageService>();
  static Future<UserModel?> getSavedUser() async {
    String userId = '';
    String username = '';
    String userPicture = '';
    String phoneNumber = '';
    String emailAddress = '';
    if (kIsWeb) {
      //* Web user reads from Web storage
      userId = WebService.readWebData(key: StorageKeys.userId) ?? '';
    } else {
      //* Mobile user reads from mobile storage
      userId =
          await storageService.readSecureData(key: StorageKeys.userId) ?? '';
    }
    if (userId.isEmpty) {
      return null;
    }
    final hiveData = await hiveStorageService.readUserDB();
    userPicture = hiveData?.photo ?? '';
    username = "${hiveData?.firstName} ${hiveData?.lastName}";
    phoneNumber = hiveData?.phoneNumber ?? '';
    emailAddress = hiveData?.email ?? '';
    String firstName = '';
    String lastName = '';
    if (username.isNotEmpty) {
      final fullname = username.split(" ");
      firstName = fullname.first;

      lastName = fullname.last;
    } else {
      firstName = username;
    }
    return UserModel(
      uid: userId,
      photo: userPicture,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: emailAddress,
    );
  }
}
