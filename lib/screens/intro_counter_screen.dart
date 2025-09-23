import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'home_screen.dart';

class IntroCounterScreen extends StatefulWidget {
  const IntroCounterScreen({super.key});

  @override
  State<IntroCounterScreen> createState() => _IntroCounterScreenState();
}

class _IntroCounterScreenState extends State<IntroCounterScreen> {
  int _counter = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // cycle 1,2,3...
    _timer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      setState(() {
        _counter++;
        if (_counter > 3) _counter = 1;
      });
    });

    // auto go to home after 3 seconds + small delay
    Future.delayed(const Duration(seconds: 4), () {
      _timer?.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) {
            return ScaleTransition(scale: anim, child: child);
          },
          child: Text(
            '$_counter',
            key: ValueKey<int>(_counter),
            style: const TextStyle(
              fontSize: 140,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }
}
