import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class CategoryTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CategoryTab({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColors.primaryColor : AppColors.lightPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
