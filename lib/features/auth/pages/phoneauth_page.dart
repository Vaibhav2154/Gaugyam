import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/pages/otp_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/auth/widgets/auth_field.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';
import 'package:gaugyam/features/home/home_screen.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const PhoneAuthScreen());
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Check if user is already signed in
    Future.microtask(() {
      ref.read(authStateNotifierProvider.notifier).checkAuthStatus();
    });
  }

  void _sendCodeToPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authStateNotifierProvider.notifier)
          .sendOtp(_phoneController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen(authStateNotifierProvider, (previous, next) {
      if (next.state == AuthState.codeSent) {
        // Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen()),
        );
      } else if (next.state == AuthState.authenticated) {
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
                      'Get Started',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppPallete.gradient1,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      'Smart Cattle Care: Detect. Feed. Breed.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppPallete.gradient1,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(height: 20),
                    AuthField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Phone Number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid phone number';
                        }
                        // Updated regex to handle just the number without country code
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authStateNotifierProvider);
                        final isLoading =
                            authState.state == AuthState.initial ||
                            authState.errorMessage == null;

                        return AuthGradientButton(
                          onPressed: _sendCodeToPhoneNumber,
                          buttonText: isLoading ? 'Send OTP' : 'Sending OTP...',
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
