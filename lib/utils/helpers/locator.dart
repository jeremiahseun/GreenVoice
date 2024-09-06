import 'package:get_it/get_it.dart';
import 'package:greenvoice/utils/constants/exports.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<GoRouter>(GreenVoiceRoutes().greenVoiceRouter);
}
