import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/dashboard/pages/add_details_page.dart';
import 'package:gaugyam/features/dashboard/pages/cattle_details_page.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> cattleList = [];
  bool isLoading = true;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchCattleData();
  }

  // Fetch cattle data from Supabase
  Future<void> _fetchCattleData() async {
    try {
      if (!mounted) return; // Prevent update if widget is disposed
      setState(() => isLoading = true);

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await supabase
          .from('cattle')
          .select()
          .eq('uuid', userId)
          .order('created_at', ascending: false);

      if (!mounted) return; // Check again before updating state

      final List<Map<String, dynamic>> fetchedCattle =
          // ignore: unnecessary_null_comparison
          response != null ? List<Map<String, dynamic>>.from(response) : [];

      setState(() {
        cattleList = fetchedCattle;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching cattle data: $error');
      if (!mounted) return;
      setState(() => isLoading = false);
      _loadCattleData();
    }
  }

  // Legacy method for backward compatibility
  Future<void> _loadCattleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('cattleData');
    if (data != null) {
      setState(() {
        cattleList = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  // Legacy method for backward compatibility
  Future<void> _saveCattleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cattleData', json.encode(cattleList));
  }

  void _addCattleProfile(Map<String, dynamic> newCattle) {
    setState(() {
      cattleList.add(newCattle);
      // Still save locally as a backup
      _saveCattleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                automaticallyImplyLeading: false,
        centerTitle: true
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppPallete.gradient1),
              )
              : cattleList.isEmpty
              ? const Center(
                child: Text(
                  "No Cattle Added Yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.gradient1,
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: cattleList.length,
                itemBuilder: (context, index) {
                  final cattle = cattleList[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      tileColor: AppPallete.whiteColor,
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            cattle['image_url'] != null
                                ? NetworkImage(cattle['image_url'])
                                : cattle['imagePath'] != null
                                ? FileImage(File(cattle['imagePath']))
                                : const AssetImage('assets/images/cow_icon.png')
                                    as ImageProvider,
                      ),
                      title: Text(
                        cattle['name'] ?? 'Unnamed Cattle',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Age: ${cattle['age']} | Breed: ${cattle['breed']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppPallete.backgroundColor,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppPallete.gradient1,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CattleDetailsPage(cattle: cattle),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPallete.gradient1,
        onPressed: () async {
          final newCattle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDetailsPage()),
          );
          if (newCattle != null) {
            _addCattleProfile(newCattle);
          }
        },
        child: const Icon(Icons.add, color: AppPallete.whiteColor),
      ),
    );
  }
}
