import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<(bool status, String message, UserCredential? user)> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName('$firstName $lastName');
      return (true, "User created", credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        return (false, "The password provided is too weak.", null);
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        return (false, "The account already exists for that email.", null);
      } else if (e.code == 'invalid-email') {
        log('The email address is badly formatted.');
        return (
          false,
          "The email address is not valid. Check it and try again",
          null
        );
      }
    } catch (e) {
      log(e.toString());
      return (false, "An error occurred", null);
    }
    return (false, "An error occurred", null);
  }

  Future<(bool status, String message, UserCredential? user)>
      signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return (true, "User Signed In successfully", credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return (false, "No user found for that email.", null);
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        return (false, "Wrong password provided for that user.", null);
      }
    }
    return (false, "An error occurred", null);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendOTP({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential?> verifyOTP(
      {required String verificationId, required String smsCode}) async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      log("Error verifying OTP: $e");
    }
    return null;
  }

  Future<(bool status, String message)> forgotPassword(
      {required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return (true, "Password reset email sent");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return (false, "No user found for that email.");
      }
      if (e.code == 'invalid-email') {
        log('The email address is badly formatted.');
        return (
          false,
          "The email address is not valid. Check it and try again"
        );
      }
      return (false, "An error occcured ");
    }
  }

  Future<void> verifyPassword({required String newPassword}) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      log("Error updating password: $e");
    }
  }
}
