import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_providers.g.dart';

// Auth state enum
enum AuthState {
  initial,
  codeSent,
  authenticated,
  error,
}

// Auth state class
class AuthStateData {
  final AuthState state;
  final String? phone;
  final String? errorMessage;
  final User? user;

  AuthStateData({
    this.state = AuthState.initial,
    this.phone,
    this.errorMessage,
    this.user,
  });

  AuthStateData copyWith({
    AuthState? state,
    String? phone,
    String? errorMessage,
    User? user,
  }) {
    return AuthStateData(
      state: state ?? this.state,
      phone: phone ?? this.phone,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}

// Auth Service
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Send OTP to phone number
  Future<AuthStateData> sendOtp(String phoneNumber) async {
    try {
      await _supabase.auth.signInWithOtp(
        phone: "+91${phoneNumber.trim()}",
      );
      
      return AuthStateData(
        state: AuthState.codeSent,
        phone: phoneNumber,
      );
    } catch (e) {
      print(e.toString());
      return AuthStateData(
        state: AuthState.error,
        errorMessage: e.toString(),
      );
    }
  }
  
  // Verify OTP
  Future<AuthStateData> verifyOtp(String phone, String otp) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        phone: "+91${phone.trim()}",
        token: otp.trim(),
        type: OtpType.sms,
      );
      
      if (response.session != null) {
        return AuthStateData(
          state: AuthState.authenticated,
          user: response.user,
        );
      } else {
        return AuthStateData(
          state: AuthState.error,
          errorMessage: 'Verification failed',
        );
      }
    } catch (e) {
      return AuthStateData(
        state: AuthState.error,
        errorMessage: e.toString(),
      );
    }
  }
  
  // Check if user is signed in
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
  
  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  
  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => 
    _supabase.auth.onAuthStateChange.map((event) {
      if (event.session != null) {
        return AuthState.authenticated;
      } else {
        return AuthState.initial;
      }
    });
}

// Auth Service Provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

// Auth State Provider
@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthStateData build() {
    // Subscribe to auth state changes
    ref.listen(authStateChangesProvider, (previous, next) {
      if (next.valueOrNull == AuthState.authenticated && state.state != AuthState.authenticated) {
        state = state.copyWith(
          state: AuthState.authenticated,
          user: ref.read(authServiceProvider).getCurrentUser(),
        );
      } else if (next.valueOrNull == AuthState.initial && state.state == AuthState.authenticated) {
        state = AuthStateData();
      }
    });
    
    return AuthStateData();
  }
  
  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(state: AuthState.initial);
    final authService = ref.read(authServiceProvider);
    final result = await authService.sendOtp(phoneNumber);
    state = result;
  }
  
  Future<void> verifyOtp(String otp) async {
    if (state.phone == null) return;
    
    final authService = ref.read(authServiceProvider);
    final result = await authService.verifyOtp(state.phone!, otp);
    state = result;
  }
  
  Future<void> checkAuthStatus() async {
    final authService = ref.read(authServiceProvider);
    final user = authService.getCurrentUser();
    
    if (user != null) {
      state = AuthStateData(
        state: AuthState.authenticated,
        user: user,
      );
    }
  }
  
  Future<void> signOut() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    state = AuthStateData();
  }
}

// Provider for listening to Supabase auth state changes
@riverpod
Stream<AuthState> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}