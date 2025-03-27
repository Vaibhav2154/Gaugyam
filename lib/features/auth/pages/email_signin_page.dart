import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/pages/email_signup_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/auth/widgets/auth_field.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';
import 'package:gaugyam/features/home/home_screen.dart';

class EmailSignInScreen extends ConsumerStatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const EmailSignInScreen());

  const EmailSignInScreen({super.key});

  @override
  ConsumerState<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends ConsumerState<EmailSignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
      } else if (next.state == AuthState.error && next.errorMessage != null) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
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
                  'Welcome Back',
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
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  obscureText: false,
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
                  },
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 30),

                // Sign In Button
                Consumer(
                  builder: (context, ref, child) {
                    // final authState = ref.watch(authStateNotifierProvider);
                    // final isLoading =
                    //     authState.state == AuthState.initial &&
                    //     authState.errorMessage == null;

                    return AuthGradientButton(
                      onPressed: _handleSignIn,
                      buttonText: 'Sign In',
                    );
                  },
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? ',
                        style: TextStyle(
                          color: AppPallete.backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailSignUpScreen(),
                          ),
                        );
                      },
                      child: Text('Sign Up',
                          style: TextStyle(
                            color: AppPallete.gradient1,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
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

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authStateNotifierProvider.notifier)
          .signIn(_emailController.text, _passwordController.text);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
