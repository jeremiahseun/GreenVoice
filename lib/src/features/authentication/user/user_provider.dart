import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/storage_service.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';

final userProvider =
    StateNotifierProvider<UserProvider, AsyncValue<UserModel?>>(
        (ref) => UserProvider(ref));

class UserProvider extends StateNotifier<AsyncValue<UserModel?>> {
  UserProvider(this.ref) : super(const AsyncValue.loading()) {
    getCurrentUser();
  }
  Ref ref;
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final firebaseFirestore = locator<FirebaseFirestoreService>();
  final storage = locator<StorageService>();

  Future<UserModel?> getCurrentUser() async {
    log("Getting current user");
    state = const AsyncValue.loading();
    try {
      final userId = await storage.readSecureData(key: StorageKeys.userId);
      if (userId.isEmpty) {
        log("User is null");
        return null;
      }
      final getUser = await firebaseFirestore.getUser(userId);
      if (!getUser.$1) {
        log("User is null");
        return null;
      }
      state = AsyncValue.data(getUser.$3);
      return getUser.$3;
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return null;
    }
  }
}
