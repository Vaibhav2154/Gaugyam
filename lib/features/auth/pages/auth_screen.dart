import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 812,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFFAFAFE)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 375,
                  height: 44,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 21,
                        top: 12,
                        child: Container(
                          width: 54,
                          height: 21,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 53,
                top: 317,
                child: SizedBox(
                  width: 270,
                  height: 63,
                  child: Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xEA722F37),
                      fontSize: 35,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 28,
                top: 434,
                child: Container(
                  width: 320,
                  height: 58,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xEA722F37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 30,
                        top: 14,
                        child: SizedBox(
                          width: 249,
                          height: 33,
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.30,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 28,
                top: 508,
                child: Container(
                  width: 320,
                  height: 58,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 235) /* White */,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xEA722F37)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 35,
                        top: 12,
                        child: SizedBox(
                          width: 249,
                          height: 33,
                          child: Text(
                            'SignUp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xEA722F37),
                              fontSize: 25,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.30,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 37,
                top: 366,
                child: SizedBox(
                  width: 311,
                  height: 40,
                  child: Text(
                    'Smart Cattle Care: Detect. Feed. Breed.',
                    style: TextStyle(
                      color: Color(0xEA722F37),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.75,
                      letterSpacing: 0.44,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 78,
                top: 59,
                child: Container(
                  width: 219,
                  height: 219,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/219x219"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}