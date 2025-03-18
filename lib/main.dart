import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gaugyam/core/theme/theme.dart';
import 'package:gaugyam/features/auth/pages/auth_screen.dart';
import 'package:gaugyam/features/auth/pages/phoneauth_page.dart';
import 'package:gaugyam/features/home/home_screen.dart';
import 'package:gaugyam/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  } catch (e) {
    print("Firebase Initialization Error: $e"); // Log error if Firebase fails
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightThemeMode,
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}
// Add this to your imports

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in
        if (snapshot.hasData) {
          // Return your home screen or dashboard
          return PhoneAuthScreen(); // Replace with your actual home page
        }
        // If the user is not logged in
        return PhoneAuthScreen();
      },
    );
  }
}
