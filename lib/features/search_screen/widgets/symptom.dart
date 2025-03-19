import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';

class SymptomsSection extends StatelessWidget {
  const SymptomsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text("Visible symptoms", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        SizedBox(height: 8),
        SymptomsRow(),
      ],
    );
  }
}

class SymptomsRow extends StatelessWidget {
  const SymptomsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        SymptomCard(title: "Blisters"),
        SymptomCard(title: "Diarrhea"),
        SymptomCard(title: "Temperature"),
      ],
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String title;
  const SymptomCard({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppPallete.gradient1,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C17396B),
            blurRadius: 20,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
