import 'package:flutter/foundation.dart';
import '../repositories/reel_repository.dart';
import 'pexels_api_service.dart';

class SeedService {
  final ReelRepository _reelRepository;
  final PexelsApiService _pexelsApiService;

  SeedService({
    required ReelRepository reelRepository,
    required PexelsApiService pexelsApiService,
  })  : _reelRepository = reelRepository,
        _pexelsApiService = pexelsApiService;

  Future<void> seedIfEmpty() async {
    try {
      final hasData = await _reelRepository.hasReels();
      if (hasData) return;

      debugPrint('Seeding reels from Pexels...');

      final videos = await _pexelsApiService.fetchVideos(
        queries: const ['dog', 'cat', 'dog and cat', 'puppy', 'kitten'],
      );

      if (videos.isEmpty) return;

      await _reelRepository.batchInsertReels(videos);
      debugPrint('Seeding complete — ${videos.length} reels inserted.');
    } catch (e) {
      debugPrint('Error seeding reels: $e');
    }
  }
}
