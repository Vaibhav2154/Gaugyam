import 'package:flutter/material.dart';
import 'package:gaugyam/features/search_screen/widgets/category_card.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        CategoryCard(title: "Doctors", color: Color(0xFFF9E9E9)),
        CategoryCard(title: "Pharmacy", color: Color(0xFFE9F2FF)),
        CategoryCard(title: "Hospitals", color: Color(0xFFE4F8EA)),
      ],
    );
  }
}
