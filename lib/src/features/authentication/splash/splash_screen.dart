import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/deep_link.dart';
import 'package:greenvoice/src/features/authentication/user/user_provider.dart';
import 'package:greenvoice/src/features/bottom_navigation/presentation/bottom_navigation.dart';
import 'package:greenvoice/src/services/firebase/auth.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay the initialization by 5 seconds
    Future.delayed(kIsWeb ? Duration.zero : const Duration(seconds: 5), () {
      if (!kIsWeb) {
        MapboxOptions.setAccessToken(dotenv.env['MAP_KEY']!);
      }
      DeepLinking.initUniLinks(context);

      ref.read(userProvider.notifier).getCurrentUser();

      // Set loading to false after 5 seconds
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      DeepLinking.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show splash loading for at least 5 seconds
      return const SplashLoading();
    }

    // Once loading is done, handle auth state
    return StreamBuilder<User?>(
      stream: firebaseAuthService
          .authStateChanges(), // Checks the auth state of the user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return HomeScreen();
        } else {
          return const SplashLoading(); // Still waiting for the authentication state
        }
      },
    );
  }
}

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/splash.gif",
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ],
        ),
      ),
    );
  }
}
