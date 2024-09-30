import 'package:flutter/material.dart';

import 'category_tab.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryTab(text: 'All', isSelected: true),
        CategoryTab(text: 'Reported'),
        CategoryTab(text: 'Voted'),
        CategoryTab(text: 'Resolved'),
      ],
    );
  }
}
