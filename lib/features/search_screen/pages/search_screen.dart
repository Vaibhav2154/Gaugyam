import 'package:flutter/material.dart';
import 'package:gaugyam/features/search_screen/pages/search_screen_content.dart';
import 'package:gaugyam/features/search_screen/pages/topics/down_cattle_management.dart';
import 'package:gaugyam/features/search_screen/widgets/category_section.dart';
import 'package:gaugyam/features/search_screen/widgets/symptom.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> topics = [
      "Down Cattle Management",
      "Nutritional Deficiencies in Cattle",
      "Common Cattle Diseases",
      "Mastitis Prevention & Treatment",
      "Heat Stress in Livestock",
      "Parasitic Infections in Cattle",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 44), // Space for status bar
            const CategorySection(),
            const SizedBox(height: 24),
            SearchScreenContent(
              topics: topics,
              content:
                  "Ensuring optimal cattle health is essential for productivity and well-being. This section provides" 
                  "comprehensive insights into common cattle diseases, their symptoms, prevention, and treatment strategies." 
                  " From mastitis management to parasite control and heat stress mitigation, explore best practices to maintain a " 
                  "healthy and thriving herd.",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
