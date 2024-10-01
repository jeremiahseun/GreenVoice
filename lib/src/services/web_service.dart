import 'package:greenvoice/utils/constants/storage_keys.dart';
import 'package:web/web.dart' as web;

class WebService {
  static String? readWebData({required String key}) {
    return web.window.localStorage.getItem(key);
    // return '';
  }

  static void writeWebData({required String key, required String value}) {
    web.window.localStorage.setItem(key, value);
  }

  static void writeUserModelData({
    required String userId,
    required String username,
    String? picture,
  }) {
    web.window.localStorage.setItem(StorageKeys.userId, userId);
    web.window.localStorage.setItem(StorageKeys.username, username);
    if (picture != null) {
      web.window.localStorage.setItem(StorageKeys.userPicture, picture);
    }
  }

  static void clearAll() {
    web.window.localStorage.clear();
  }
}
