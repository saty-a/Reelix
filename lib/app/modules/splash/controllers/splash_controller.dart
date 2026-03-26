import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initScreen();
  }

  Future<void> initScreen() async {
    debugPrint('Splash screen initialized');
    try {
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('Attempting to navigate to home screen');
      await Get.offAllNamed(Routes.HOME, predicate: (route) => false);
      debugPrint('Navigation completed');
    } catch (e) {
      debugPrint('Error during navigation: $e');
    }
  }
}
