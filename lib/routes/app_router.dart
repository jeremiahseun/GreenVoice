import 'package:greenvoice/src/features/authentication/register/presentation/register.dart';
import 'package:greenvoice/utils/constants/exports.dart';

final greenVoice = locator<GoRouter>();

class GreenVoiceRoutes {
  final greenVoiceRouter = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const Register(),
    )
  ]);
}
