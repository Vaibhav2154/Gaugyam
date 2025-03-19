import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/breeding_prog/widgets/build_selection.dart';

class NaturalBreedingPage extends StatelessWidget {
  const NaturalBreedingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         // Matching theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Natural Breeding',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppPallete.gradient1,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Natural breeding is the traditional method of reproduction where a male and female mate without human intervention. This process ensures genetic diversity and is commonly used in livestock and wildlife breeding programs.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  BuildSelection.buildCard('Step 1: Selection of Mating Pair', 'Healthy male and female animals are chosen based on genetic traits and physical health.'),
                  BuildSelection.buildCard('Step 2: Natural Mating', 'The selected animals are allowed to interact in a controlled environment to ensure natural mating.'),
                  BuildSelection.buildCard('Step 3: Monitoring the Female', 'The female is observed for signs of successful mating and pregnancy.'),
                  BuildSelection.buildCard('Step 4: Pregnancy Confirmation', 'Veterinarians confirm pregnancy using ultrasound or physical examination.'),
                  BuildSelection.buildCard('Step 5: Gestation & Care', 'The pregnant female receives proper nutrition and medical care until birth.'),
                  BuildSelection.buildCard('Step 6: Birth & Offspring Care', 'The newborn animals are monitored for health and well-being after birth.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 
}
