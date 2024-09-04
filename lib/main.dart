import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/routes/app_router.dart';
import 'package:greenvoice/utils/helpers/locator.dart';

void main() async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: GreenVoice()));

  await setupLocator();
}

class GreenVoice extends StatelessWidget {
  const GreenVoice({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: greenVoice.routeInformationParser,
      routeInformationProvider: greenVoice.routeInformationProvider,
      routerDelegate: greenVoice.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'GreenVoice',
      theme: ThemeData(),
    );
  }
}
