import 'package:get/get.dart';
import '../../../data/repositories/reel_repository.dart';
import '../../../data/services/seed_service.dart';
import '../../../data/services/video_cache_service.dart';
import '../../reel/controllers/reel_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(seedService: Get.find<SeedService>()),
    );

    Get.lazyPut<ReelController>(
      () => ReelController(
        reelRepository: Get.find<ReelRepository>(),
        videoCacheService: Get.find<VideoCacheService>(),
      ),
    );
  }
}
