import 'package:flutter/material.dart';
import 'package:gaugyam/features/breeding_prog/artificial_insem.dart';
import 'package:gaugyam/features/breeding_prog/embryo_trans.dart';
import 'package:gaugyam/features/breeding_prog/natural_breed.dart';

class BreedingProg extends StatefulWidget {
  const BreedingProg({super.key});

  @override
  State<BreedingProg> createState() => _BreedingProgState();
}

class _BreedingProgState extends State<BreedingProg> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
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
              buildSectionTitle("1. Select the Breeding Technique"),
              buildBreedingButton("Natural Breeding", () {Navigator.push(context, MaterialPageRoute(builder: (context) => NaturalBreedingPage()));}),
              buildBreedingButton("Artificial Insemination", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ArtificialInseminationPage()));
              }),
              buildBreedingButton("Embryo Transfer", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EmbryoTransferPage()));
              }),
              SizedBox(height: 20),
              buildSectionTitle("2. Prepare Cows for Breeding"),
              buildInfoText("Before breeding, ensure:"),
              buildChecklist([
                "The cow is in good health (check for diseases or deficiencies).",
                "The cow has a healthy body condition score (BCS 5-7 out of 9).",
                "Vaccinations are up to date (to prevent reproductive diseases).",
                "Proper nutrition (high protein & mineral-rich diet for fertility).",
              ]),
              SizedBox(height: 20),
              buildSectionTitle("3. Recognizing Heat Signs"),
              buildInfoText("Heat Signs (Cows in Estrus):"),
              buildChecklist([
                "Standing Heat: The cow stands still when mounted by another cow.",
                "Increased Activity: More walking, restless behavior.",
                "Mucus Discharge: Clear, stretchy vaginal mucus.",
                "Swollen Vulva: Red and slightly swollen.",
                "✅ Best Time for Breeding: 12-18 hours after the cow starts standing heat."
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF722F37)),
      ),
    );
  }

  Widget buildBreedingButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF722F37),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildChecklist(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• ", style: TextStyle(fontSize: 16, color: Color(0xFF722F37))),
            Expanded(child: Text(item, style: TextStyle(fontSize: 14))),
          ],
        ),
      )).toList(),
    );
  }
}
