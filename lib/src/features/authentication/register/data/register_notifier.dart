// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:greenvoice/utils/constants/exports.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future<void> createGreenVoiceUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    log('Triggering code');
    try {
      state = state.copyWith(loadingState: LoadingState.loading);
      final registerUser = _firebaseAuthService.createUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber);

      state = state.copyWith(loadingState: LoadingState.success);
      if (registerUser == true) {
        log(' I don enter the code o');
      }
    } catch (e) {
      log('Something went wrong $e');
      state = state.copyWith(loadingState: LoadingState.error);
    }
  }
}

class RegisterState {
  LoadingState loadingState;
  RegisterState({
    this.loadingState = LoadingState.idle,
  });

  RegisterState copyWith({
    LoadingState? loadingState,
  }) {
    return RegisterState(
      loadingState: loadingState ?? this.loadingState,
    );
  }
}

enum LoadingState { loading, success, error, idle }
