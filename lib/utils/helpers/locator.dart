import 'package:get_it/get_it.dart';
import 'package:greenvoice/routes/app_router.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<GoRouter>(GreenVoiceRoutes().greenVoiceRouter);
}
