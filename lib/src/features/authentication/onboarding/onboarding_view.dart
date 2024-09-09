import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/services/firebase/auth.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
