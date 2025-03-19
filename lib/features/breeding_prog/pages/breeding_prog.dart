import 'package:flutter/material.dart';
import 'package:gaugyam/features/breeding_prog/pages/artificial_insem.dart';
import 'package:gaugyam/features/breeding_prog/pages/embryo_trans.dart';
import 'package:gaugyam/features/breeding_prog/pages/natural_breed.dart';
import 'package:gaugyam/core/utils/build_selection.dart';

class BreedingProg extends StatefulWidget {
  const BreedingProg({super.key});

  @override
  State<BreedingProg> createState() => _BreedingProgState();
}

class _BreedingProgState extends State<BreedingProg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
              'Breeding Program',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. Prepare Cows for Breeding"),
            BuildSelection.buildInfoText("Before breeding, ensure:"),
            BuildSelection.buildChecklist([
              "The cow is in good health (check for diseases or deficiencies).",
              "The cow has a healthy body condition score (BCS 5-7 out of 9).",
              "Vaccinations are up to date (to prevent reproductive diseases).",
              "Proper nutrition (high protein & mineral-rich diet for fertility).",
            ]),
            SizedBox(height: 20),
            BuildSelection.buildSectionTitle("2. Recognizing Heat Signs"),
            BuildSelection.buildInfoText("Heat Signs (Cows in Estrus):"),
            BuildSelection.buildChecklist([
              "Standing Heat: The cow stands still when mounted by another cow.",
              "Increased Activity: More walking, restless behavior.",
              "Mucus Discharge: Clear, stretchy vaginal mucus.",
              "Swollen Vulva: Red and slightly swollen.",
              "✅ Best Time for Breeding: 12-18 hours after the cow starts standing heat.",
            ]),
            BuildSelection.buildSectionTitle("3. Select the Breeding Technique"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,

                children: [
                  BuildSelection.buildBreedingButton("Natural Breeding", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NaturalBreedingPage(),
                      ),
                    );
                  }),
                  BuildSelection.buildBreedingButton("Artificial Insemination", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtificialInseminationPage(),
                      ),
                    );
                  }),
                  BuildSelection.buildBreedingButton("Embryo Transfer", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmbryoTransferPage(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
