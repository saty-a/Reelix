import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelix/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import 'app_binding.dart';
import 'data/values/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  ThemeData _createThemeData(bool isDark) {
    return ThemeData(
      primaryColor: AppColors.defaultPrimaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.defaultPrimaryColor,
        secondary: AppColors.defaultSecondaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.defaultPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.defaultPrimaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: "Reelix",
        navigatorKey: GlobalKeys.navigationKey,
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.SPLASH,
        getPages: AppPages.routes,
        smartManagement: SmartManagement.full,
        defaultTransition: Transition.leftToRight,
        initialBinding: AppBinding(),
        theme: _createThemeData(false),
        darkTheme: _createThemeData(true),
        themeMode: ThemeMode.system,
      );
    });
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
