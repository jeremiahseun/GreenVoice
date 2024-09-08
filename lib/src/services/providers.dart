import 'package:greenvoice/src/features/authentication/login/data/login_notifier.dart';
import 'package:greenvoice/src/features/authentication/register/data/register_notifier.dart';
import 'package:greenvoice/src/services/firebase/firestore.dart';
import 'package:greenvoice/utils/constants/exports.dart';

final registerNotifier =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(
      firebaseFirestoreService: FirebaseFirestoreService(),
      firebaseAuthService: FirebaseAuthService()),
);
final loginNotifier =
    StateNotifierProvider.autoDispose<LoginScreenNotifier, LoginScreenState>(
  (ref) => LoginScreenNotifier(
      firebaseFirestoreService: FirebaseFirestoreService(),
      firebaseAuthService: FirebaseAuthService()),
);
