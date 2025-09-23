import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:quiz_application/features/bg/bg.dart';
import 'package:quiz_application/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PurpleBackground(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated "Quiz" text
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Quizify',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                      speed: Duration(milliseconds: 500),
                    ),
                  ],
                  totalRepeatCount: 1,
                  isRepeatingAnimation: false, // This is crucial!
                  onFinished: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// colors
const colorizeColors = [Colors.white, Colors.purple, Colors.yellow, Colors.red];

// font style
const colorizeTextStyle = TextStyle(
  fontSize: 50.0,
  fontFamily: 'Horizon',
  fontWeight: FontWeight.w900,
);
