import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/appColors.dart';
import 'package:flutter_application_1/Utils/appfonts.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;

  const CategoryItem(
      {super.key, required this.categoryName, required this.categoryIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white1,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(categoryIcon, size: 40, color: AppColors.blue1),
          const SizedBox(height: 8),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: AppFonts.font14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
