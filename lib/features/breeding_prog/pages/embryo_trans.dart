import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/core/utils/build_selection.dart';

class EmbryoTransferPage extends StatelessWidget {
  const EmbryoTransferPage({super.key});

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
                color: AppPallete.gradient1,
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
                  BuildSelection.buildCard('Step 1: Superovulation', 'The donor female is hormonally treated to produce multiple eggs.'),
                  BuildSelection.buildCard('Step 2: Artificial Insemination', 'The donor is inseminated with semen from a genetically superior male.'),
                  BuildSelection.buildCard('Step 3: Embryo Collection', 'Fertilized embryos are collected from the donor using non-surgical techniques.'),
                  BuildSelection.buildCard('Step 4: Embryo Evaluation', 'Embryos are assessed for quality and viability before transfer.'),
                  BuildSelection.buildCard('Step 5: Embryo Transfer', 'Healthy embryos are implanted into recipient females for gestation.'),
                  BuildSelection.buildCard('Step 6: Pregnancy Monitoring', 'Recipient females are monitored for pregnancy and development.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  
}
