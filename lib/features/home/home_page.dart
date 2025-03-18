import 'package:flutter/material.dart';
import 'package:gaugyam/features/breeding_prog/breeding_prog.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
              margin: EdgeInsets.all(15),
              width: double.infinity,
              height: 60,
              // color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Text("Hello Farmer, 👋"), ),
            Container(
              child: Column(
                children: [
                 ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => BreedingProg()));},  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF722F37), // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ), child: Text("Breeding Assistant"))
                ],
              ),
            ),
            SizedBox(height: 100,),
            Text("Nearest Visit", style: TextStyle(color: Color(0xFF394D6D),)),
            Container(
              child: Text("Nearest Doctor Visited"),
            )
          ])),
      ));
  }
}