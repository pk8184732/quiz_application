import 'package:flutter/material.dart';
import 'package:quiz_application/themes/app_theme.dart';
import 'package:quiz_application/utils/sizes.dart';

import '../app_importer.dart';
import 'colors.dart';

class SnackBarHelper {
  static void showMessage(
      String title,
      String message, {
        Duration duration = const Duration(seconds: 2),
        SnackPosition position = SnackPosition.BOTTOM,
      }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: ThemeController.instance.isDarkMode ? lightRed : darkRed,
      colorText:Colors.white,
      margin: const EdgeInsets.all(mediumMargin),
      borderRadius: smallBorderRadius,
      duration: duration,
    );
  }
}
