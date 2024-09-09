import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier to manage selected index
class BottomNavigationNotifier extends StateNotifier<int> {
  BottomNavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

// Provider for accessing the notifier
final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationNotifier, int>(
  (ref) => BottomNavigationNotifier(),
);
