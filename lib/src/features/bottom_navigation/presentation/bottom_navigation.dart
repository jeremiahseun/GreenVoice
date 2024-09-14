import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/bottom_navigation/data/bottom_navigation_notifier.dart';
import 'package:greenvoice/src/features/issues/presentation/issues_home.dart';

import 'package:greenvoice/src/features/projects/presentation/projects.dart';
import 'package:greenvoice/src/features/profile/presentation/profile_view.dart';




class HomeScreen extends ConsumerWidget {
  final List<Widget> _screens = [
    const IssuesView(),


    // const MapView(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Screen 1'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Screen 3'),
        ],
      ),
    );
  }
}
