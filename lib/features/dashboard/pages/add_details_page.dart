import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';
import 'package:gaugyam/features/dashboard/widgets/dashbaoard_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDetailsPageState createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController historyController = TextEditingController();
  final TextEditingController medicalController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController vaccineController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  File? _image;
  bool _isUploading = false;
  final supabase = Supabase.instance.client;
  final uuid = Uuid();

  late final String cattleUUID;
  
  @override
  void initState() {
    super.initState();
    cattleUUID = uuid.v4();
  }


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to Supabase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final String fileName = '${uuid.v4()}${path.extension(imageFile.path)}';
      await supabase.storage
          .from('cattleimages')
          .upload(fileName, imageFile);
      
      // Get public URL for the uploaded file
      final imageUrl = supabase.storage
          .from('cattleimages')
          .getPublicUrl(fileName);
          
      return imageUrl;
    } catch (error) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
        content: Text('Error uploading image: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
          ),
        );
      }
      print('Error uploading image: $error');
      return null;
    }
  }

  // Store cattle data in Supabase with user ID
  Future<Map<String, dynamic>> _storeCattleData(Map<String, dynamic> cattleData) async {
    try {
      // Get current user ID
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Add the user ID to the cattle data
      cattleData['uuid'] = userId;
      
      // Insert data and return the inserted row
      final response = await supabase
          .from('cattle')
          .insert(cattleData)
          .select()
          .single();
      
      return response;
    } catch (error) {
      print('Error storing cattle data: $error');
      // Return original data if Supabase fails
      return cattleData;
    }
  }

  void _handleAddCattle() {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        breedController.text.isEmpty) {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isUploading = true);
    
    // Create initial cattle profile
    final cattleProfile = {
      'name': nameController.text,
      'age': ageController.text,
      'dob': dobController.text,
      'gender': genderController.text,
      'breed': breedController.text,
      'history': historyController.text,
      'medical': medicalController.text,
      'vaccine': vaccineController.text,
      'medicines': medicineController.text,
      'imagePath': _image?.path, // Keep for local storage compatibility
      'created_at': DateTime.now().toIso8601String(),
    };
    
    _processAndSaveData(cattleProfile);
  }
  
  // Handle the async operations separately
  Future<void> _processAndSaveData(Map<String, dynamic> profile) async {
    try {
      // Upload image if available
      if (_image != null) {
        final imageUrl = await _uploadImage(_image!);
        profile['image_url'] = imageUrl;
      }
      
      // Store in Supabase
      final storedProfile = await _storeCattleData(profile);
      
      
      if (mounted) {
        setState(() => _isUploading = false);
        Navigator.pop(context, storedProfile);
      }
    } catch (error) {
      print('Error processing cattle data: $error');
      if (mounted) {
        setState(() => _isUploading = false);
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding cattle: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cattle Details')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _image != null
                              ? FileImage(_image!)
                              : const AssetImage('assets/images/cow_icon.png')
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(nameController, 'Cattle Name'),
                  _buildTextField(ageController, 'Age'),
                  _buildDatePickerField(dobController, 'Date of Birth'),
                  _buildTextField(genderController, 'Gender'),
                  _buildTextField(breedController, 'Breed'),
                  _buildTextField(historyController, 'Personal History'),
                  _buildTextField(medicalController, 'Medical History'),
                  _buildTextField(vaccineController, 'Vaccination History'),
                  _buildTextField(medicineController, 'Medicines & Supplements'),
                  const SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: 'Add Cattle',
                    onPressed: _isUploading ? () {} : _handleAddCattle,
                  ),
                ],
              ),
            ),
          ),
          if (_isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DashboardField(
        hintText: label,
        controller: controller,
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text =
                  "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
            });
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: AppPallete.whiteColor),
            decoration: InputDecoration(
              fillColor: AppPallete.backgroundColor,
              filled: true,
              hintText: label,
              hintStyle: const TextStyle(color: AppPallete.greyColor),
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: Color(0xFF722F37),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF722F37), width: 2),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF722F37), width: 3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}