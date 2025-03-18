import 'package:flutter/material.dart';

class NaturalBreedingPage extends StatelessWidget {
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
                color: Colors.black,
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
                  _buildCard('Step 1: Selection of Mating Pair', 'Healthy male and female animals are chosen based on genetic traits and physical health.'),
                  _buildCard('Step 2: Natural Mating', 'The selected animals are allowed to interact in a controlled environment to ensure natural mating.'),
                  _buildCard('Step 3: Monitoring the Female', 'The female is observed for signs of successful mating and pregnancy.'),
                  _buildCard('Step 4: Pregnancy Confirmation', 'Veterinarians confirm pregnancy using ultrasound or physical examination.'),
                  _buildCard('Step 5: Gestation & Care', 'The pregnant female receives proper nutrition and medical care until birth.'),
                  _buildCard('Step 6: Birth & Offspring Care', 'The newborn animals are monitored for health and well-being after birth.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String description) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
