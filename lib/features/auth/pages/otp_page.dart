import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/auth/widgets/auth_field.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';
import 'package:gaugyam/features/home/home_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authStateNotifierProvider.notifier)
          .verifyOtp(_otpController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen(authStateNotifierProvider, (previous, next) {
      if (next.state == AuthState.authenticated) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else if (next.state == AuthState.error && next.errorMessage != null) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', height: 200, width: 300),
              const SizedBox(height: 80),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Verified',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppPallete.gradient1,
                        fontSize: 35,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthField(
                      controller: _otpController,
                      hintText: 'Enter OTP',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 6) {
                          return 'Please enter a valid 6-digit OTP';
                        }
                        return null;
                      }, obscureText: false,
                    ),
                    SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authStateNotifierProvider);
                        final isLoading =
                            authState.state == AuthState.initial &&
                            authState.errorMessage == null;

                        return AuthGradientButton(
                          onPressed: isLoading ? () {} : _verifyOtp,
                          buttonText: isLoading ? 'Verifying...' : 'Verify OTP',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
