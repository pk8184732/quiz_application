import 'package:flutter/material.dart';
import 'package:quiz_application/utils/colors.dart';

class PurpleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkRed,
            lightRed,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(left: -30, top: 60, child: _bubble(140, 0.10)),
          Positioned(right: -20, top: 40, child: _bubble(90, 0.14)),
          Positioned(right: 40, top: 180, child: _bubble(60, 0.10)),
          Positioned(right: -20, bottom: 40, child: _bubble(90, 0.14)),
          Positioned(left: 40, bottom: 180, child: _bubble(60, 0.10)),
          Positioned(left: 20, top: 220, child: _bubble(40, 0.12)),
        ],
      ),
    );
  }

  Widget _bubble(double s, double o) => Container(
    width: s,
    height: s,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(o),
      shape: BoxShape.circle,
    ),
  );
}
