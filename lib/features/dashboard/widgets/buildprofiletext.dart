import 'package:flutter/material.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';

class BuildProfileText{

    static Widget buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppPallete.gradient1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? "Not provided",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: AppPallete.primaryFgColor),
          ),
        ],
      ),
    );
  }
}