import 'package:flutter/material.dart';
import 'package:gaugyam/core/utils/build_selection.dart';

class CommonCattleDiseases extends StatefulWidget {
  const CommonCattleDiseases({super.key});

  @override
  State<CommonCattleDiseases> createState() => _CommonCattleDiseasesState();
}

class _CommonCattleDiseasesState extends State<CommonCattleDiseases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Common Cattle Diseases',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. Foot and Mouth Disease (FMD)"),
            BuildSelection.buildInfoText("Highly contagious viral infection affecting hooved animals."),
            BuildSelection.buildChecklist([
              "Causes: Virus spread through direct contact, contaminated feed, or air.",
              "Symptoms: Fever, blisters in the mouth and hooves, drooling, weight loss.",
              "Prevention: Vaccination, quarantine new animals, maintain hygiene.",
              "Treatment: No specific cure, supportive care, and anti-inflammatory drugs.",
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("2. Bovine Respiratory Disease (BRD)"),
            BuildSelection.buildInfoText("A major respiratory illness affecting cattle, especially in stressful conditions."),
            BuildSelection.buildChecklist([
              "Causes: Bacteria, viruses, and environmental stress.",
              "Symptoms: Coughing, nasal discharge, fever, difficulty breathing.",
              "Prevention: Proper ventilation, stress reduction, timely vaccinations.",
              "Treatment: Antibiotics, anti-inflammatory medications, fluid therapy.",
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("3. Mastitis"),
            BuildSelection.buildInfoText("Inflammation of the udder, affecting milk production."),
            BuildSelection.buildChecklist([
              "Causes: Bacterial infection due to poor milking hygiene.",
              "Symptoms: Swollen udder, reduced milk yield, abnormal milk (bloody or watery).",
              "Prevention: Maintain hygiene, regular udder checks, proper milking techniques.",
              "Treatment: Antibiotics, pain relief medications, proper sanitation.",
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("4. Johne’s Disease"),
            BuildSelection.buildInfoText("A chronic intestinal disease leading to severe weight loss."),
            BuildSelection.buildChecklist([
              "Causes: Mycobacterium avium paratuberculosis (MAP) infection.",
              "Symptoms: Chronic diarrhea, weight loss, decreased milk production.",
              "Prevention: Test and cull infected animals, provide clean water and feed.",
              "Treatment: No effective cure, control measures to prevent spread.",
            ]),
            SizedBox(height: 20),

            BuildSelection.buildSectionTitle("5. Blackleg"),
            BuildSelection.buildInfoText("A fatal bacterial disease affecting young cattle."),
            BuildSelection.buildChecklist([
              "Causes: Clostridium chauvoei bacteria present in soil.",
              "Symptoms: Swelling in muscles, fever, sudden death.",
              "Prevention: Vaccination, proper disposal of dead animals.",
              "Treatment: High-dose antibiotics if caught early, usually fatal.",
            ]),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
