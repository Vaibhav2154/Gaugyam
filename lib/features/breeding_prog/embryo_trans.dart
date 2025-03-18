import 'package:flutter/material.dart';

class EmbryoTransferPage extends StatelessWidget {
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
              'Embryo Transfer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Embryo transfer is an advanced reproductive technique used in animal breeding. It involves the transfer of fertilized embryos from a donor female to recipient females, allowing for genetic improvement and increased reproductive efficiency.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCard('Step 1: Superovulation', 'The donor female is hormonally treated to produce multiple eggs.'),
                  _buildCard('Step 2: Artificial Insemination', 'The donor is inseminated with semen from a genetically superior male.'),
                  _buildCard('Step 3: Embryo Collection', 'Fertilized embryos are collected from the donor using non-surgical techniques.'),
                  _buildCard('Step 4: Embryo Evaluation', 'Embryos are assessed for quality and viability before transfer.'),
                  _buildCard('Step 5: Embryo Transfer', 'Healthy embryos are implanted into recipient females for gestation.'),
                  _buildCard('Step 6: Pregnancy Monitoring', 'Recipient females are monitored for pregnancy and development.'),
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
