import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/features/auth/pages/phoneauth_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/home/home_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using Riverpod to watch auth state changes
    final authState = ref.watch(authStateNotifierProvider);
    
    if (authState.state == AuthState.authenticated) {
      return DashboardScreen();
    }
    return const PhoneAuthScreen();
  }
}