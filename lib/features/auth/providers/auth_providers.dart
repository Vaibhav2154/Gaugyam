import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  final String? verificationId;
  final String? errorMessage;
  final User? user;

  AuthStateData({
    this.state = AuthState.initial,
    this.verificationId,
    this.errorMessage,
    this.user,
  });

  AuthStateData copyWith({
    AuthState? state,
    String? verificationId,
    String? errorMessage,
    User? user,
  }) {
    return AuthStateData(
      state: state ?? this.state,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}

// Auth Service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Send OTP to phone number
  Future<AuthStateData> sendOtp(String phoneNumber) async {
    try {
      Completer<AuthStateData> completer = Completer<AuthStateData>();
      
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneNumber.trim()}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification completed
          await _auth.signInWithCredential(credential);
          completer.complete(AuthStateData(
            state: AuthState.authenticated,
            user: _auth.currentUser,
          ));
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(AuthStateData(
            state: AuthState.error,
            errorMessage: e.message,
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(AuthStateData(
            state: AuthState.codeSent,
            verificationId: verificationId,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Only complete if not already completed
          if (!completer.isCompleted) {
            completer.complete(AuthStateData(
              state: AuthState.codeSent,
              verificationId: verificationId,
            ));
          }
        },
      );
      
      return await completer.future;
    } catch (e) {
      return AuthStateData(
        state: AuthState.error,
        errorMessage: e.toString(),
      );
    }
  }
  
  // Verify OTP
  Future<AuthStateData> verifyOtp(String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp.trim(),
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      
      return AuthStateData(
        state: AuthState.authenticated,
        user: userCredential.user,
      );
    } on FirebaseAuthException catch (e) {
      return AuthStateData(
        state: AuthState.error,
        errorMessage: e.message,
      );
    }
  }
  
  // Check if user is signed in
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
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
    return AuthStateData();
  }
  
  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(state: AuthState.initial);
    final authService = ref.read(authServiceProvider);
    final result = await authService.sendOtp(phoneNumber);
    state = result;
  }
  
  Future<void> verifyOtp(String otp) async {
    if (state.verificationId == null) return;
    
    final authService = ref.read(authServiceProvider);
    final result = await authService.verifyOtp(state.verificationId!, otp);
    state = result;
  }
  
  Future<void> checkAuthStatus() async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.getCurrentUser();
    
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