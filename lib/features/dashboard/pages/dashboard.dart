import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';
import 'package:gaugyam/features/dashboard/widgets/buildprofiletext.dart';
import 'package:gaugyam/features/dashboard/widgets/dashbaoard_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cattle Manager',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[50],
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
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
 // Update the _fetchCattleData method to handle null response
Future<void> _fetchCattleData() async {
  try {
    setState(() => isLoading = true);
    
    final response = await supabase
        .from('cattle')
        .select()
        .order('created_at', ascending: false);
    
    // Check if response is null or empty
    if (response == null) {
      // Handle null response
      setState(() {
        cattleList = [];
        isLoading = false;
      });
      return;
    }
    
    final List<Map<String, dynamic>> fetchedCattle = List<Map<String, dynamic>>.from(response);
    
    setState(() {
      cattleList = fetchedCattle;
      isLoading = false;
    });
  } catch (error) {
    print('Error fetching cattle data: $error');
    setState(() => isLoading = false);
    
    // Fallback to local storage if Supabase fails
    _loadCattleData();
  }
}

// Update the _storeCattleData method to better handle errors
Future<Map<String, dynamic>> _storeCattleData(Map<String, dynamic> cattleData) async {
  try {
    // Check if the table exists first
    final tableExists = await _checkTableExists('cattle');
    if (!tableExists) {
      print('Table "cattle" does not exist');
      return cattleData; // Return original data if table doesn't exist
    }
    
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

// Add a method to check if the table exists
Future<bool> _checkTableExists(String tableName) async {
  try {
    // Try to get a single row from the table
    await supabase
        .from(tableName)
        .select('*')
        .limit(1);
    return true;
  } catch (error) {
    if (error.toString().contains('404') || 
        error.toString().contains('Not Found')) {
      return false;
    }
    // For other errors, assume the table exists but there's another issue
    return true;
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
      appBar: AppBar(centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : cattleList.isEmpty
              ? const Center(
                  child: Text(
                    "No Cattle Added Yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
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
                        tileColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: cattle['image_url'] != null
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
                            color: Colors.black,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.brown,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CattleDetailsPage(cattle: cattle),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF722F37),
        onPressed: () async {
          final newCattle = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDetailsPage()),
          );
          if (newCattle != null) {
            _addCattleProfile(newCattle);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage({super.key});

  @override
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
      final storageResponse = await supabase.storage
          .from('cattle_images')
          .upload(fileName, imageFile);
      
      // Get public URL for the uploaded file
      final imageUrl = supabase.storage
          .from('cattle_images')
          .getPublicUrl(fileName);
          
      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  // Store cattle data in Supabase
  Future<Map<String, dynamic>> _storeCattleData(Map<String, dynamic> cattleData) async {
    try {
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
        // Optionally show error message
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
            ],
          ),
        ),
      ),
    );
  }
}