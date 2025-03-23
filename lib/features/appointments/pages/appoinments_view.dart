import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';

class ViewAppointmentsPage extends StatefulWidget {
  const ViewAppointmentsPage({super.key});

  @override
  _ViewAppointmentsPageState createState() => _ViewAppointmentsPageState();
}

class _ViewAppointmentsPageState extends State<ViewAppointmentsPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final response = await supabase.from('appointments').select('*');
    return response;
  }

  Future<void> updateStatus(String appointmentId, String newStatus) async {
  await supabase.from('appointments').update({'status': newStatus}).eq('id', appointmentId);
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Appointments'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: AppPallete.gradient1));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }
          final appointments = snapshot.data ?? [];
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                color: AppPallete.gradient1,
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Doctor: ${appointment['doctor_name']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Cow ID: ${appointment['cattle_id']}', style: TextStyle(color: Colors.white70)),
                      Text('Date: ${appointment['date']}', style: TextStyle(color: Colors.white70)),
                      Text('Time: ${appointment['time']}', style: TextStyle(color: Colors.white70)),
                      Text('Status: ${appointment['status']}', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            dropdownColor: AppPallete.backgroundColor,
                            value: appointment['status'],
                            items: ['Scheduled', 'Completed', 'Cancelled']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status, style: TextStyle(color: Colors.white)),
                                    ))
                                .toList(),
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                await updateStatus(appointment['id'].toString(), newStatus);
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await updateStatus(appointment['id'].toString(), 'Cancelled');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
