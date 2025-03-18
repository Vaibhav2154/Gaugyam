import 'package:flutter/material.dart';

class ArtificialInseminationPage extends StatelessWidget {
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
              'Artificial Insemination',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Artificial insemination (AI) is a reproductive technique where sperm is collected from a male and manually introduced into the female’s reproductive tract, increasing the chances of fertilization while allowing for selective breeding.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCard('Step 1: Semen Collection', 'Semen is collected from a genetically superior male under hygienic conditions.'),
                  _buildCard('Step 2: Semen Evaluation', 'The collected semen is assessed for quality, motility, and viability.'),
                  _buildCard('Step 3: Semen Processing', 'Semen is diluted with a suitable extender to enhance longevity and storage.'),
                  _buildCard('Step 4: Storage & Transport', 'Semen is preserved at optimal conditions and transported to breeding centers.'),
                  _buildCard('Step 5: Insemination Process', 'Semen is introduced into the female’s reproductive tract at the right time for fertilization.'),
                  _buildCard('Step 6: Pregnancy Monitoring', 'The female is monitored for successful conception and pregnancy progression.'),
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
