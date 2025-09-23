import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_application/general_bindings.dart';
import 'package:quiz_application/routes/app_pages.dart';
import 'package:quiz_application/routes/app_routes.dart';
import 'package:quiz_application/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemeController());
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Quizify",
        initialBinding: GeneralBindings(),
        getPages: AppRoutePages.getPages,
        initialRoute: AppRoutes.start,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,

        // Performance optimizations
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        smartManagement: SmartManagement.keepFactory,
      ),
    );
  }
}