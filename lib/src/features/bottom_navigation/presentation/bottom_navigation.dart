import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/bottom_navigation/data/bottom_navigation_notifier.dart';
import 'package:greenvoice/src/features/issues/presentation/issues_home.dart';
import 'package:greenvoice/src/features/profile/presentation/profile_view.dart';
import 'package:greenvoice/src/features/projects/presentation/projects.dart';

class HomeScreen extends ConsumerWidget {
  final List<Widget> _screens = [
    const IssuesView(),
    const ProjectHome(),
    const ProfileView()
  ];

  HomeScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
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
