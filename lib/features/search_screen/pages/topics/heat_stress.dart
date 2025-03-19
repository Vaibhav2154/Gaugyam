import 'package:flutter/material.dart';
import 'package:gaugyam/core/utils/build_selection.dart';








class HeatStress extends StatefulWidget {
  const HeatStress({super.key});

  @override
  State<HeatStress> createState() => _HeatStressState();
}

class _HeatStressState extends State<HeatStress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Heat Stress in Livestock',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. Signs of Heat Stress"),
            BuildSelection.buildChecklist([
              "Increased breathing rate and panting.",
              "Reduced feed intake and milk production.",
              "Excessive salivation and restlessness.",
              "Seeking shade or water sources frequently."
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("2. Prevention Strategies"),
            BuildSelection.buildChecklist([
              "Ensure proper ventilation in barns and shelters.",
              "Provide ample shade using trees, sheds, or artificial covers.",
              "Adjust feeding times to cooler parts of the day.",
              "Increase air circulation using fans or sprinklers."
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("3. Immediate Relief Measures"),
            BuildSelection.buildChecklist([
              "Move cattle to shaded or cooler areas.",
              "Provide continuous access to cool, clean water.",
              "Use water sprays or misting systems to cool animals.",
              "Reduce physical handling and transport during extreme heat."
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("4. Long-term Management"),
            BuildSelection.buildChecklist([
              "Select heat-resistant breeds or crossbreeds.",
              "Modify housing structures to enhance cooling.",
              "Optimize feeding plans with proper electrolyte balance.",
              "Monitor weather conditions and adjust management accordingly."
            ]),
          ],
        ),
      ),
    );
  }
}