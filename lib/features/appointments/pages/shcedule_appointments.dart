import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/appointments/pages/appoinments_view.dart';
import 'package:gaugyam/features/appointments/widgets/auth_gradient_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScheduleAppointmentPageState createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String? selectedCow;
  String? doctorName;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<Map<String, dynamic>> cattleList = [];

  @override
  void initState() {
    super.initState();
    fetchCattle();
  }

  Future<void> fetchCattle() async {
  final response = await supabase.from('cattle').select('id, name');
  
  if (!mounted) return; // Check if widget is still in the tree

  setState(() {
    cattleList = response.map((cow) => {'id': cow['id'], 'name': cow['name']}).toList();
  });
}

  Future<void> scheduleAppointment() async {
    if (selectedCow == null ||
        doctorName == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }

    await supabase.from('appointments').insert({
      'user_id': supabase.auth.currentUser?.id,
      'cattle_id': selectedCow,
      'doctor_name': doctorName,
      'date': selectedDate.toString().split(' ')[0],
      'time': "${selectedTime!.hour}:${selectedTime!.minute}",
      'status': 'Scheduled',
      'created_at': DateTime.now().toIso8601String(),
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Appointment Scheduled')));
    setState(() {
      selectedCow = null;
      doctorName = null;
      selectedDate = null;
      selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                automaticallyImplyLeading: false,
        title: Text("Schedule Appointment")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              dropdownColor:
                  AppPallete.backgroundColor, // Set background color to black
              focusColor:
                  AppPallete.backgroundColor, // Set focus color to black
              value: selectedCow,
              hint: Text(
                "Select Cow",
                style: TextStyle(
                  color: Colors.white,
                ), // Ensure hint text is visible
              ),
              items:
                  cattleList.map((cow) {
                    return DropdownMenuItem(
                      value: cow['id'].toString(),
                      child: Text(
                        cow['name'],
                        style: TextStyle(
                          color: Colors.white,
                        ), // Set text color to white for visibility
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCow = value.toString();
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    AppPallete
                        .backgroundColor, // Background color for the form field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white), // Border color
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Doctor Name",
                hintStyle: TextStyle(color: AppPallete.whiteColor),
                filled: true,
                fillColor: AppPallete.backgroundColor,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPallete.gradient1, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppPallete.transparentColor,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) => doctorName = value,
            ),
            SizedBox(height: 20),
            AppointmentButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              buttonText: "Pick Date",
            ),
            SizedBox(height: 20),
            AppointmentButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
              buttonText: "Pick Time",
            ),
            SizedBox(height: 20),
            AppointmentButton(
              onPressed: scheduleAppointment,
              buttonText: "Schedule",
            ),
            SizedBox(height: 20),
            AppointmentButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAppointmentsPage(),
                  ),
                );
              },
              buttonText: "View Appointments",
            ),          ],
        ),
      ),
    );
  }
}
