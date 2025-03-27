import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/pages/email_signin_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/auth/widgets/auth_field.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';
import 'package:gaugyam/features/home/home_screen.dart';

class EmailSignUpScreen extends ConsumerStatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => const EmailSignUpScreen(),
      );

  const EmailSignUpScreen({super.key});

  @override
  ConsumerState<EmailSignUpScreen> createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends ConsumerState<EmailSignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      } else if (next.state == AuthState.emailVerification) {
        // Show email verification message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email'),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (next.state == AuthState.error && next.errorMessage != null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Image.asset('assets/images/logo.png', height: 200, width: 300),
                const SizedBox(height: 40),
                
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPallete.gradient1,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Email Field
                AuthField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }, obscureText: false,
                ),
                const SizedBox(height: 20),

                // Password Field
                AuthField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  }, keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 30),

                // Sign Up Button
                Consumer(
                  builder: (context, ref, child) {
                    // final authState = ref.watch(authStateNotifierProvider);
                    // final isLoading =
                    //     authState.state == AuthState.initial &&
                    //     authState.errorMessage == null;

                    return AuthGradientButton(
                      onPressed: _handleSignUp,
                      buttonText: 'Sign Up',
                    );
                  },
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                      style: TextStyle(
                        color: AppPallete.backgroundColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailSignInScreen(),
                          ),
                        );
                      },
                      child: Text('Sign In',
                        style: TextStyle(
                          color: AppPallete.gradient1,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authStateNotifierProvider.notifier).signUp(
            _emailController.text, 
            _passwordController.text,
            phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
          );
          setState(() {
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}