import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/auth/pages/phoneauth_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/breeding_prog/breeding_prog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes for navigation
    ref.listen<AuthStateData>(authStateNotifierProvider, (previous, current) {
      // If the user was authenticated before but now is not (signed out)
      if (previous?.state == AuthState.authenticated && 
          current.state != AuthState.authenticated) {
        // Navigate to phone auth page and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
          (route) => false, // This removes all previous routes
        );
      }
    });

    return  Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(
              color: AppPallete.gradient1,
            ),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppPallete.whiteColor,
                ),
                margin: EdgeInsets.all(15),
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hello Farmer, 👋"),
                    // Sign out button
                    GestureDetector(
                      onTap: () async {
                        // Sign out using Riverpod auth provider
                        await ref.read(authStateNotifierProvider.notifier).signOut();
                        
                        // Alternative approach: If the listener doesn't work, navigate directly
                        // This is a fallback in case the listener doesn't trigger
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(PhoneAuthScreen.route(), (route) => false);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Color(0xFF722F37), size: 18),
                          SizedBox(width: 4),
                          Text(
                            "Sign Out",
                            style: TextStyle(
                              color: Color(0xFF722F37),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreedingProg(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF722F37), // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text("Breeding Assistant"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              Text("Nearest Visit", style: TextStyle(color: Color(0xFF394D6D))),
              Container(child: Text("Nearest Doctor Visited")),
            ],
          ),
        ),
    );
  }
}