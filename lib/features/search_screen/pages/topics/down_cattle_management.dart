import 'package:flutter/material.dart';
import 'package:gaugyam/core/utils/build_selection.dart';

class CattleHealth extends StatefulWidget {
  const CattleHealth({super.key});

  @override
  State<CattleHealth> createState() => _CattleHealthState();
}

class _CattleHealthState extends State<CattleHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Cattle Health Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildSelection.buildSectionTitle("1. Down Cattle Management"),
            BuildSelection.buildInfoText("Key steps for handling down cattle:"),
            BuildSelection.buildChecklist([
              "Assess the cause (injury, illness, metabolic disorder).",
              "Provide soft bedding to prevent pressure sores.",
              "Ensure proper hydration and nutritional support.",
              "Use assisted lifting devices if necessary.",
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("2. Common Cattle Diseases"),
            BuildSelection.buildInfoText("Diseases affecting cattle health:"),
            BuildSelection.buildChecklist([
              "Foot and Mouth Disease (FMD) - viral infection causing blisters.",
              "Bovine Respiratory Disease - leads to coughing and fever.",
              "Mastitis - udder infection affecting milk production.",
              "Johne’s Disease - chronic intestinal infection.",
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("3. Vaccination & Disease Prevention"),
            BuildSelection.buildInfoText("Regular vaccinations help prevent common cattle diseases."),
            BuildSelection.buildChecklist([
              "FMD Vaccine - Prevents Foot and Mouth Disease.",
              "Bovine Respiratory Disease Vaccine - Reduces lung infections.",
              "Brucellosis Vaccine - Prevents reproductive health issues.",
              "Clostridial Vaccine - Protects against bacterial infections.",
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("4. Parasite Control"),
            BuildSelection.buildInfoText("Parasites can severely impact cattle health and productivity."),
            BuildSelection.buildChecklist([
              "Deworming every 3-6 months based on vet recommendations.",
              "Regular checks for ticks and lice to prevent infections.",
              "Use of anti-parasitic sprays and medicines.",
              "Maintaining hygienic living conditions to prevent infestations.",
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("5. Wound Care and Injury Management"),
            BuildSelection.buildInfoText("Proper wound care prevents infections and speeds healing."),
            BuildSelection.buildChecklist([
              "Clean wounds with antiseptic solutions.",
              "Apply antibiotic ointments to prevent infections.",
              "Bandage severe wounds to protect against dirt.",
              "Consult a vet for deep wounds or infections.",
            ]),
            SizedBox(height: 20),
            
            BuildSelection.buildSectionTitle("6. Emergency Handling & First Aid"),
            BuildSelection.buildInfoText("Quick response in emergencies can save lives."),
            BuildSelection.buildChecklist([
              "Have a first aid kit with antiseptics, bandages, and pain relievers.",
              "Monitor vital signs (temperature, heartbeat, breathing).",
              "Separate injured cattle from the herd to prevent further harm.",
              "Call a veterinarian for serious cases.",
            ]),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}