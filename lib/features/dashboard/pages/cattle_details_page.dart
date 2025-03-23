import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/dashboard/pages/dashboard.dart';
import 'package:gaugyam/features/dashboard/widgets/buildprofiletext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CattleDetailsPage extends StatefulWidget {
  final Map<String, dynamic> cattle;
  
  const CattleDetailsPage({super.key, required this.cattle});

  @override
  _CattleDetailsPageState createState() => _CattleDetailsPageState();
}

class _CattleDetailsPageState extends State<CattleDetailsPage> {
  late SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cattle['name'] ?? "Cattle Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: widget.cattle['image_url'] != null
                      ? NetworkImage(widget.cattle['image_url'])
                      : widget.cattle['imagePath'] != null
                          ? FileImage(File(widget.cattle['imagePath']))
                          : const AssetImage('assets/images/cow_icon.png')
                              as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              BuildProfileText.buildDetailRow("Name", widget.cattle['name']),
              BuildProfileText.buildDetailRow("Id", widget.cattle['id'].toString()),
              BuildProfileText.buildDetailRow("Age", widget.cattle['age']),
              BuildProfileText.buildDetailRow("Date of Birth", widget.cattle['dob']),
              BuildProfileText.buildDetailRow("Gender", widget.cattle['gender']),
              BuildProfileText.buildDetailRow("Breed", widget.cattle['breed']),
              BuildProfileText.buildDetailRow("Personal History", widget.cattle['history']),
              BuildProfileText.buildDetailRow("Medical History", widget.cattle['medical']),
              BuildProfileText.buildDetailRow("Vaccination History", widget.cattle['vaccine']),
              BuildProfileText.buildDetailRow("Medicines & Supplements", widget.cattle['medicines']),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _deleteCattle(),
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

  void _deleteCattle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cattle'),
        content: Text('Are you sure you want to delete ${widget.cattle['name']}?'),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                }
                
                // Delete the cattle record
                if (widget.cattle['id'] != null) {
                  await supabase.from('cattle').delete().eq('id', widget.cattle['id']);
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cattle deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                }
              } catch (error) {
                if (mounted) {
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
