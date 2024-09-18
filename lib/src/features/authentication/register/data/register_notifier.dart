// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final registerNotifierProvider =
    ChangeNotifierProvider.autoDispose((ref) => RegisterNotifier());

class RegisterNotifier extends GreenVoiceNotifier {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService firebaseFirestoreService =
      FirebaseFirestoreService();
  bool isObscurePassword = false;

  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  Future<(bool status, String message)> createGreenVoiceUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      startLoading();
      final registerUser = await firebaseAuthService.registerUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber);

      stopLoading();
      if (registerUser.$1 == true) {
        log(' ${registerUser.$3?.user?.uid.toString()}');
        final String userId = registerUser.$3?.user?.uid ?? '';
        final UserModel userModel = UserModel(
            uid: userId,
            lastName: lastName,
            firstName: firstName,
            email: email,
            photo: '');
        await firebaseFirestoreService.createUser(userModel);
        return (true, 'Registration Successful');
      } else {
        return (false, (registerUser.$2));
      }
    } catch (e) {
      log('Something went wrong $e');
      stopLoading();
      return (false, 'An error occured: $e');
    }
  }
}
