import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaugyam/features/auth/pages/otp_page.dart';
import 'package:gaugyam/features/auth/widgets/auth_field.dart';
import 'package:gaugyam/features/auth/widgets/auth_gradient_button.dart';


class PhoneAuthScreen extends StatefulWidget {
  @override
  PhoneAuthScreenState createState() => PhoneAuthScreenState();
}

class PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _verificationId;

  void _sendCodeToPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieval or instant verification
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', height: 300,width: 300,),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    AuthField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: 'Phone Number',
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'^\+\d{1,3}\d{9,10}$').hasMatch(value)) {
                          return 'Please enter a valid phone number with country code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AuthGradientButton(
                      onPressed: _sendCodeToPhoneNumber,
                      buttonText: 'Send OTP',
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