import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final Color color;
  const CategoryCard({required this.title, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 88,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C17396B),
            blurRadius: 20,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(title, style: const TextStyle(fontSize: 14,color: AppPallete.backgroundColor,)),
      ),
    );
  }
}