import 'package:uuid/uuid.dart';

var uuid = const Uuid();

String generateUniqueID() {
  // Generate a v1 (time-based) id
  final uid = uuid.v1();

  return uid;
}