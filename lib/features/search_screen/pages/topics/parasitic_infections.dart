import 'package:flutter/material.dart';
import 'package:gaugyam/core/utils/build_selection.dart';

class ParasiticInfections extends StatefulWidget {
  const ParasiticInfections({super.key});

  @override
  State<ParasiticInfections> createState() => _ParasiticInfectionsState();
}

class _ParasiticInfectionsState extends State<ParasiticInfections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parasitic Infections in Cattle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. Common Parasites"),
            BuildSelection.buildChecklist([
              "Ticks - Cause skin irritation and transmit diseases.",
              "Worms - Lead to weight loss and poor digestion.",
              "Lice - Cause itching, hair loss, and skin infections.",
              "Flies - Spread infections and disturb cattle comfort."
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("2. Symptoms of Parasitic Infections"),
            BuildSelection.buildChecklist([
              "Weight loss and reduced milk production.",
              "Scratching, biting, and rubbing against objects.",
              "Diarrhea and weakness.",
              "Visible parasites on the skin or in feces."
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("3. Prevention Strategies"),
            BuildSelection.buildChecklist([
              "Regular deworming and tick control programs.",
              "Maintaining clean and dry living conditions.",
              "Rotational grazing to minimize parasite buildup.",
              "Using insecticides and natural repellents."
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("4. Treatment Options"),
            BuildSelection.buildChecklist([
              "Consulting a veterinarian for appropriate medications.",
              "Using anti-parasitic drugs as prescribed.",
              "Providing a balanced diet to boost immunity.",
              "Ensuring proper hydration and mineral supplementation."
            ]),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}