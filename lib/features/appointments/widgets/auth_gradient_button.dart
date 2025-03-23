import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppointmentButton extends StatelessWidget {
  const AppointmentButton({super.key,required this.buttonText,required this.onPressed});
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        
        color: AppPallete.gradient1,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.gradient1,
          shadowColor: AppPallete.transparentColor,
          fixedSize: Size(395, 55),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: AppPallete.whiteColor,
          ),
        ),
      ),
    );
  }
}
