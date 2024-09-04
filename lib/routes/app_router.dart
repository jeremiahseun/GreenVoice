import 'package:greenvoice/routes/app_router.dart';
import 'package:greenvoice/src/features/authentication/sign_in/presentation/sign_in.dart';
import 'package:greenvoice/utils/helpers/locator.dart';

export 'package:go_router/go_router.dart';

final greenVoice = locator<GoRouter>();

class GreenVoiceRoutes {
  final greenVoiceRouter = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignIn(),
    )
  ]);
}
