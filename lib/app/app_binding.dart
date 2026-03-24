import 'package:get/get.dart';

import 'data/repositories/reel_repository.dart';
import 'data/repositories/reel_repository_impl.dart';
import 'data/services/pexels_api_service.dart';
import 'data/services/pexels_api_service_impl.dart';
import 'data/services/seed_service.dart';
import 'data/services/video_cache_service.dart';
import 'modules/splash/controllers/splash_controller.dart';

class AppBinding extends Bindings {
  static const _pexelsApiKey =
      'wDJ1P17waRaWZOMPPpxUm5t8b2rGrZJkOrVE7qqIYtsfCLalHw0rz7xi';

  @override
  void dependencies() {
    Get.put<ReelRepository>(ReelRepositoryImpl(), permanent: true);

    Get.put<PexelsApiService>(
      PexelsApiServiceImpl(apiKey: _pexelsApiKey),
      permanent: true,
    );

    Get.put<SeedService>(
      SeedService(
        reelRepository: Get.find<ReelRepository>(),
        pexelsApiService: Get.find<PexelsApiService>(),
      ),
      permanent: true,
    );

    Get.put<VideoCacheService>(VideoCacheService(), permanent: true);

    Get.put(SplashController(), permanent: true);
  }
}
