import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/authentication/login/presentation/login.dart';
import 'package:greenvoice/src/services/firebase/auth.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: firebaseAuthService
          .authStateChanges(), // Checks the auth state of the user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in
            return const SplashScreen(); // Replace with your home screen
          } else {
            // User is not logged in
            return const Login(); // Replace with your login screen
          }
        } else {
          // Still waiting for authentication state
          return const SplashScreen(); // Replace with a loading or splash screen
        }
      },
    );
  }
}
