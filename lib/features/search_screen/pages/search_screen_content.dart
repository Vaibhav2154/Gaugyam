import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/search_screen/pages/topics/common_cattle_diseases.dart';
import 'package:gaugyam/features/search_screen/pages/topics/down_cattle_management.dart';
import 'package:gaugyam/features/search_screen/pages/topics/heat_stress.dart';
import 'package:gaugyam/features/search_screen/pages/topics/mastittis_presention.dart';
import 'package:gaugyam/features/search_screen/pages/topics/nutrition.dart';
import 'package:gaugyam/features/search_screen/pages/topics/parasitic_infections.dart';

class SearchScreenContent extends StatelessWidget {
  final List<String> topics;
  final String content;

  const SearchScreenContent({super.key, required this.topics, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Popular Topics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppPallete.accentFgColor,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SearchScreenCard(title: topics[0], widget: CattleHealth()),
                  SearchScreenCard(title: topics[1], widget: NutritionalDeficiencies()),
                  SearchScreenCard(title: topics[2], widget: CommonCattleDiseases()),
                  SearchScreenCard(title: topics[3], widget: MastitisPrevention()),
                  SearchScreenCard(title: topics[4], widget: HeatStress()),
                  SearchScreenCard(title: topics[5], widget: ParasiticInfections()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreenCard extends StatelessWidget {
  final String title;
  final Widget widget;
  const SearchScreenCard({required this.title, super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>widget)
        );
      },  
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppPallete.gradient1,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
