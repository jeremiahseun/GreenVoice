import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenvoice/routes/app_router.dart';

import 'package:greenvoice/utils/styles/styles.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: GreenVoice()));

  // await setupLocator();
  Animate.restartOnHotReload = true;
}

class GreenVoice extends StatelessWidget {
  const GreenVoice({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser:
          GreenVoiceRoutes().greenVoiceRouter.routeInformationParser,
      routeInformationProvider:
          GreenVoiceRoutes().greenVoiceRouter.routeInformationProvider,
      routerDelegate: GreenVoiceRoutes().greenVoiceRouter.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'GreenVoice',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: AppColors.primaryColor),
          textTheme: GoogleFonts.publicSansTextTheme(),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: GoogleFonts.publicSans(),
            ),
          )),
    );
  }
}
