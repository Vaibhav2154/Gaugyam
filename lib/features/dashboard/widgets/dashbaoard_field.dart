import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';

class DashboardField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputType keyboardType;
  const DashboardField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    required String? Function(dynamic value) validator, required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: AppPallete.whiteColor),
      cursorColor: AppPallete.gradient1,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppPallete.whiteColor),
        filled: true,
        fillColor: AppPallete.backgroundColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppPallete.gradient1, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppPallete.transparentColor,
            width: 1.5,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
