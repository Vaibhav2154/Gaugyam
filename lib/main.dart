import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/theme.dart';
import 'package:gaugyam/features/auth/pages/phoneauth_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/home/home_screen.dart';
import 'package:gaugyam/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  } catch (e) {
    print("Firebase Initialization Error: $e"); // Log error if Firebase fails
  }
  runApp(
    // Wrap the entire app with ProviderScope to enable Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize auth state check when app starts
    Future.microtask(() {
      ref.read(authStateNotifierProvider.notifier).checkAuthStatus();
    });
    
    return MaterialApp(
      title: 'Gaugyam',
      theme: AppTheme.lightThemeMode,
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

// Convert AuthWrapper to use Riverpod
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state from Riverpod provider
    final authState = ref.watch(authStateNotifierProvider);
    
    // If authenticated, go to home screen, otherwise to phone auth
    return authState.state == AuthState.authenticated
        ? PhoneAuthScreen() // Your home screen
        : PhoneAuthScreen();
        
    // Alternatively, you can still use StreamBuilder with Riverpod:
    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return MainScreen();
    //     }
    //     return PhoneAuthScreen();
    //   },
    // );
  }
}