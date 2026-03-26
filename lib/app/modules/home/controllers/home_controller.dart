import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/exit_confirmation_dialog.dart';
import '../../../data/services/seed_service.dart';
import '../../reel/controllers/reel_controller.dart';
import '../../reel/views/reel_view.dart';
import '../views/home_view.dart';

class HomeController extends GetxController {
  final SeedService _seedService;

  HomeController({required SeedService seedService})
      : _seedService = seedService;

  RxInt currentIndex = 0.obs;

  static const int _reelTabIndex = 1;

  @override
  void onInit() {
    super.onInit();
    _seedService.seedIfEmpty();
  }

  void onBackPressed() {
    if (currentIndex.value != 0) {
      changeTab(0);
    } else {
      Get.dialog(
        ExitConfirmationDialog(
          primaryMessage: "Exit App",
          secondaryMessage: "Are you sure you want to exit the app?",
          accept: () => exit(0),
          decline: () => Get.back(result: false),
          declineMessage: "No",
          acceptMessage: "Yes",
        ),
      );
    }
  }

  void changeTab(int index) {
    final wasOnReels = currentIndex.value == _reelTabIndex;
    final goingToReels = index == _reelTabIndex;

    currentIndex.value = index;

    final reelCtrl = Get.find<ReelController>();

    if (wasOnReels && !goingToReels) {
      reelCtrl.pauseCurrentVideo();
    } else if (!wasOnReels && goingToReels) {
      reelCtrl.resumeCurrentVideo();
    }
  }

  void onReelTabDoubleTap() {
    if (currentIndex.value != _reelTabIndex) {
      changeTab(_reelTabIndex);
    }
    Get.find<ReelController>().refreshReels();
  }

  final pages = <Widget>[const HomeFeed(), const ReelView()];
}
