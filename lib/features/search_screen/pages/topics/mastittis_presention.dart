import 'package:flutter/material.dart';
import 'package:gaugyam/core/utils/build_selection.dart';

class MastitisPrevention extends StatefulWidget {
  const MastitisPrevention({super.key});

  @override
  State<MastitisPrevention> createState() => _MastitisPreventionState();
}

class _MastitisPreventionState extends State<MastitisPrevention> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mastitis Prevention & Treatment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. What is Mastitis?"),
            BuildSelection.buildInfoText(
                "Mastitis is an infection of the udder tissue in dairy cattle, "
                "causing inflammation and reduced milk production."),

            SizedBox(height: 10),
            BuildSelection.buildSectionTitle("2. Causes of Mastitis"),
            BuildSelection.buildChecklist([
              "Bacterial infections (Staphylococcus, Streptococcus, E. coli).",
              "Poor milking hygiene and contaminated milking equipment.",
              "Injuries or cracks on teats leading to bacterial entry.",
              "Dirty bedding and lack of proper udder care.",
              "Stress and weakened immune system in cattle."
            ]),

            SizedBox(height: 10),
            BuildSelection.buildSectionTitle("3. Symptoms of Mastitis"),
            BuildSelection.buildChecklist([
              "Swollen, hard, or painful udder.",
              "Changes in milk consistency (watery, clots, or pus).",
              "Decreased milk production and appetite.",
              "Increased body temperature and fever.",
              "Reluctance to let calves nurse or be milked."
            ]),

            SizedBox(height: 10),
            BuildSelection.buildSectionTitle("4. Prevention Strategies"),
            BuildSelection.buildChecklist([
              "Maintain proper milking hygiene (clean hands, disinfected teats).",
              "Ensure clean and dry bedding to reduce bacterial exposure.",
              "Use post-milking teat dips to prevent infections.",
              "Regularly test cows for mastitis and monitor milk quality.",
              "Provide a balanced diet with adequate vitamins and minerals."
            ]),

            SizedBox(height: 10),
            BuildSelection.buildSectionTitle("5. Treatment Methods"),
            BuildSelection.buildChecklist([
              "Antibiotic therapy prescribed by a veterinarian.",
              "Frequent and complete milking to clear infection.",
              "Using anti-inflammatory medications for pain relief.",
              "Providing proper hydration and supportive care.",
              "Isolating infected cows to prevent disease spread."
            ]),

            SizedBox(height: 10),
            BuildSelection.buildSectionTitle("6. Impact of Mastitis"),
            BuildSelection.buildInfoText(
                "Mastitis not only affects cattle health but also leads to economic "
                "losses due to reduced milk production and quality."),
          ],
        ),
      ),
    );
  }
}
