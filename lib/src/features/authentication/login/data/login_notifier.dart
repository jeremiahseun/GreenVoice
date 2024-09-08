// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/utils/helpers/enums.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final loginNotifierProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginScreenNotifier());

class LoginScreenNotifier extends GreenVoiceNotifier {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService firebaseFirestoreService =
      FirebaseFirestoreService();
  bool isObscurePassword = false;

  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  Future<bool> loginGreenVoiceUser({
    required String email,
    required String password,
  }) async {
    log('Triggering code');
    startLoading();
    try {
      final registerUser = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      stopLoading();

      if (registerUser.$1 == true) {
        log(' Sign IN successful');
      } else {
        log(registerUser.$2);
      }
      return true;
    } catch (e) {
      log('Something went wrong $e');
      stopLoading();
      return false;
    }
  }
}

class LoginScreenState {
  LoadingState loadingState;
  bool isSelected;
  bool isSuccessful;
  LoginScreenState(
      {this.loadingState = LoadingState.idle,
      this.isSelected = true,
      this.isSuccessful = false});

  LoginScreenState copyWith({
    LoadingState? loadingState,
    bool? isSelected,
    bool? isSuccessful,
  }) {
    return LoginScreenState(
      loadingState: loadingState ?? this.loadingState,
      isSelected: isSelected ?? this.isSelected,
      isSuccessful: isSuccessful ?? this.isSuccessful,
    );
  }
}
