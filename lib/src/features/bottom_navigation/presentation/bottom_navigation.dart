import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/bottom_navigation/data/bottom_navigation_notifier.dart';
import 'package:greenvoice/src/features/issues/presentation/issues_home.dart';
import 'package:greenvoice/src/features/profile/presentation/profile_view.dart';
import 'package:greenvoice/src/features/projects/presentation/projects.dart';

class HomeScreen extends ConsumerWidget {
  final List<Widget> _screens = [
    const IssuesView(key: PageStorageKey('page1')),
    const ProjectHome(key: PageStorageKey('page2')),
    const ProfileView(key: PageStorageKey('page3'))
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationProvider);
    // Create a PageStorageBucket to preserve state
    final PageStorageBucket bucket = PageStorageBucket();

    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 400),
          reverse: currentIndex <
              ref.read(bottomNavigationProvider.notifier).previousIndex,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: _screens[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavigationProvider.notifier).setIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.globe2Outline), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.compost_sharp), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
