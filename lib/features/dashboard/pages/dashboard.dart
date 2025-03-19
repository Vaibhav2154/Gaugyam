import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _loadCattleData();
  }

  Future<void> _loadCattleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('cattleData');
    if (data != null) {
      setState(() {
        cattleList = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveCattleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cattleData', json.encode(cattleList));
  }

  void _addCattleProfile(Map<String, dynamic> newCattle) {
    setState(() {
      cattleList.add(newCattle);
      _saveCattleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true),
      body: cattleList.isEmpty
          ? const Center(
              child: Text(
                "No Cattle Added Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.brown),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cattleList.length,
              itemBuilder: (context, index) {
                final cattle = cattleList[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    tileColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: cattle['imagePath'] != null
                          ? FileImage(File(cattle['imagePath']))
                          : const AssetImage('assets/default_cow.png') as ImageProvider,
                    ),
                    title: Text(cattle['name'] ?? 'Unnamed Cattle',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                    subtitle: Text('Age: ${cattle['age']} | Breed: ${cattle['breed']}',
                        style: const TextStyle(fontSize: 14, color: Colors.black)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.brown),
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cattle Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/default_cow.png') as ImageProvider,
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF722F37),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      breedController.text.isNotEmpty) {
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
                      'imagePath': _image?.path,
                    };
                    Navigator.pop(context, cattleProfile);
                  }
                },
                child: const Text('Add Cattle', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black), // Fixed text color to black
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF722F37), width: 2)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF722F37), width: 3)),
        ),
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
            controller.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF722F37)),
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
    return Scaffold(
      appBar: AppBar(title: Text(cattle['name'] ?? "Cattle Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: cattle['imagePath'] != null
                    ? FileImage(File(cattle['imagePath']))
                    : const AssetImage('assets/default_cow.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Name", cattle['name']),
            _buildDetailRow("Age", cattle['age']),
            _buildDetailRow("Date of Birth", cattle['dob']),
            _buildDetailRow("Gender", cattle['gender']),
            _buildDetailRow("Breed", cattle['breed']),
            _buildDetailRow("Personal History", cattle['history']),
            _buildDetailRow("Medical History", cattle['medical']),
            _buildDetailRow("Vaccination History", cattle['vaccine']),
            _buildDetailRow("Medicines & Supplements", cattle['medicines']),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF722F37))),
          const SizedBox(height: 4),
          Text(value ?? "Not provided", style: const TextStyle(fontSize: 14, color: Colors.black)),
          const Divider(),
        ],
      ),
    );
  }
}
