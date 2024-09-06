import 'package:greenvoice/src/features/authentication/register/data/register_notifier.dart';
import 'package:greenvoice/utils/constants/exports.dart';

final registerNotifier =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(),
);
