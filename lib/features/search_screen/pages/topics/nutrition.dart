import 'package:flutter/material.dart';
import 'package:gaugyam/core/utils/build_selection.dart';





class NutritionalDeficiencies extends StatefulWidget {
  const NutritionalDeficiencies({super.key});

  @override
  State<NutritionalDeficiencies> createState() => _NutritionalDeficienciesState();
}

class _NutritionalDeficienciesState extends State<NutritionalDeficiencies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutritional Deficiencies in Cattle',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. Common Nutrient Deficiencies"),
            BuildSelection.buildChecklist([
              "Calcium Deficiency - Causes milk fever, weak bones, and muscle tremors.",
              "Phosphorus Deficiency - Leads to reduced appetite, slow growth, and reproductive issues.",
              "Vitamin A Deficiency - Causes night blindness, weak immunity, and reproductive failure.",
              "Protein Deficiency - Results in weight loss, poor coat condition, and reduced milk yield.",
              "Copper Deficiency - Leads to anemia, poor coat color, and weak immune response.",
              "Selenium Deficiency - Causes white muscle disease and increased calf mortality.",
              "Iodine Deficiency - Results in goiter and weak newborn calves."
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("2. Symptoms of Nutritional Deficiencies"),
            BuildSelection.buildChecklist([
              "Weight loss and poor growth rate.",
              "Low fertility and weak calves.",
              "Frequent infections and slow recovery from illnesses.",
              "Poor coat quality and hair loss.",
              "Weak bones and difficulty in movement."
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("3. Prevention and Management"),
            BuildSelection.buildChecklist([
              "Provide a balanced diet with essential minerals and vitamins.",
              "Use high-quality forage and supplement with mineral blocks.",
              "Ensure access to fresh, clean water at all times.",
              "Monitor cattle health regularly and adjust feed accordingly.",
              "Consult a veterinarian for diet plans and deficiency treatments."
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("4. Recommended Supplements"),
            BuildSelection.buildChecklist([
              "Mineral Mixes: Provide balanced calcium, phosphorus, and trace minerals.",
              "Vitamin A & D Injections: Help prevent deficiencies in young calves.",
              "Protein Supplements: Improve milk production and overall health.",
              "Selenium and Iodine Supplements: Essential for calf health and reproduction."
            ]),
          ],
        ),
      ),
    );
  }
}
