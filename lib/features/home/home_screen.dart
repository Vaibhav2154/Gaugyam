import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/appointments/pages/shcedule_appointments.dart';
import 'package:gaugyam/features/cowfeedingassistant/pages/cow_feeding_assitant_screen.dart';
import 'package:gaugyam/features/dashboard/pages/dashboard.dart';
import 'package:gaugyam/features/home/home_page.dart';




class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    DashboardScreen(),
    ScheduleAppointmentPage(),
    CowFeedingAssistantScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: _pages[_selectedIndex], // Replace IndexedStack with direct widget
    bottomNavigationBar: BottomNavigationBar(
      enableFeedback: true,
      backgroundColor: AppPallete.whiteColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Cattles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.food_bank),
          label: 'Feed Planner',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppPallete.gradient1,
      unselectedItemColor: Color(0xFF929CAD),
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HomePage(),
      ),
    );
  }
}



class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                automaticallyImplyLeading: false,
        title: Text('Appointment')),
      body: Center(child: Text('Appointment Page')),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                automaticallyImplyLeading: false,
        title: Text('Dashboard')),
      body: DashboardPage(),
    );
  }
}
