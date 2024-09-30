import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier to manage selected index
class BottomNavigationNotifier extends StateNotifier<int> {
  int previousIndex = 0;
  BottomNavigationNotifier() : super(0);

  void setIndex(int index) {
    previousIndex = state;
    state = index;
  }
}

// Provider for accessing the notifier
final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationNotifier, int>(
  (ref) => BottomNavigationNotifier(),
);
