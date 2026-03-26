import 'package:get/get.dart';
import '../../../data/repositories/reel_repository.dart';
import '../../../data/services/video_cache_service.dart';
import '../controllers/reel_controller.dart';

class ReelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelController>(
      () => ReelController(
        reelRepository: Get.find<ReelRepository>(),
        videoCacheService: Get.find<VideoCacheService>(),
      ),
    );
  }
}
