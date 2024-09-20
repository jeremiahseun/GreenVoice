import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/deep_link.dart';
import 'package:greenvoice/src/features/authentication/user/user_provider.dart';
import 'package:greenvoice/src/features/bottom_navigation/presentation/bottom_navigation.dart';
import 'package:greenvoice/src/services/firebase/auth.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    DeepLinking.initUniLinks(context);
    ref.read(userProvider.notifier).getCurrentUser();
  }

  @override
  void dispose() {
    DeepLinking.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: firebaseAuthService
          .authStateChanges(), // Checks the auth state of the user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return HomeScreen();
        } else {
          // Still waiting for authentication state
          return const SplashLoading(); // Replace with a loading or splash screen
        }
      },
    );
  }
}

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator.adaptive(
              backgroundColor: Colors.black,
            ),
            Gap(15),
            Text("Loading...")
          ],
        ),
      ),
    );
  }
}
