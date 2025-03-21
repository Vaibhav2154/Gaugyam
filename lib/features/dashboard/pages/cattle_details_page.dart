import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/dashboard/widgets/buildprofiletext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



// Cattle Details Page
class CattleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cattle;
  
  const CattleDetailsPage({super.key, required this.cattle});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    
    return Scaffold(
      appBar: AppBar(title: Text(cattle['name'] ?? "Cattle Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: cattle['image_url'] != null
                      ? NetworkImage(cattle['image_url'])
                      : cattle['imagePath'] != null
                          ? FileImage(File(cattle['imagePath']))
                          : const AssetImage('assets/images/cow_icon.png')
                              as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              BuildProfileText.buildDetailRow("Name", cattle['name']),
              BuildProfileText.buildDetailRow("Age", cattle['age']),
              BuildProfileText.buildDetailRow("Date of Birth", cattle['dob']),
              BuildProfileText.buildDetailRow("Gender", cattle['gender']),
              BuildProfileText.buildDetailRow("Breed", cattle['breed']),
              BuildProfileText.buildDetailRow("Personal History", cattle['history']),
              BuildProfileText.buildDetailRow("Medical History", cattle['medical']),
              BuildProfileText.buildDetailRow("Vaccination History", cattle['vaccine']),
              BuildProfileText.buildDetailRow("Medicines & Supplements", cattle['medicines']),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _deleteCattle(context, cattle, supabase),
                icon: const Icon(Icons.delete, color: AppPallete.whiteColor),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: AppPallete.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Method to delete cattle
  void _deleteCattle(BuildContext context, Map<String, dynamic> cattle, SupabaseClient supabase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cattle'),
        content: Text('Are you sure you want to delete ${cattle['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context); // Close dialog
                                // Delete the cattle record
                if (cattle['id'] != null) {
                  await supabase
                      .from('cattle')
                      .delete()
                      .eq('id', cattle['id']);
                      Navigator.pop(context);
                  // // Delete image from storage if exists
                  // if (cattle['image_url'] != null) {
                  //   final fileName = cattle['image_url'].split('/').last;
                  //   await supabase.storage
                  //       .from('cattle_images')
                  //       .remove([fileName]);
                  // }
                }
                
                // Close loading indicator and navigate back to dashboard
                Navigator.pop(context);
                Navigator.pop(context);
                
                // Refresh the dashboard
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cattle deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                // Close loading indicator
                Navigator.pop(context);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting cattle: ${error.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}