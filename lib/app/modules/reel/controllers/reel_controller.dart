import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/dto/reel.dart';
import '../../../data/repositories/reel_repository.dart';
import '../../../data/services/video_cache_service.dart';

class ReelController extends GetxController with WidgetsBindingObserver {
  final ReelRepository _reelRepository;
  final VideoCacheService _videoCacheService;

  ReelController({
    required ReelRepository reelRepository,
    required VideoCacheService videoCacheService,
  })  : _reelRepository = reelRepository,
        _videoCacheService = videoCacheService;

  final reels = <Reel>[].obs;
  final isLoading = true.obs;
  final currentIndex = 0.obs;
  final isVideoPlaying = true.obs;
  final isOffline = false.obs;

  final Map<int, VideoPlayerController> _videoControllers = {};
  final Set<int> _initializing = {};

  final _controllerRevision = 0.obs;

  static const int _preloadCount = 1;
  static const int _maxAliveDistance = 2;
  static const int _preCacheCount = 5;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _listenConnectivity();
    _fetchReels();
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    super.onClose();
  }

  @override
  void didHaveMemoryPressure() {
    debugPrint('Memory pressure — releasing non-current players');
    final current = currentIndex.value;
    final keysToRemove =
        _videoControllers.keys.where((key) => key != current).toList();
    for (final key in keysToRemove) {
      _videoControllers[key]?.dispose();
      _videoControllers.remove(key);
    }
    _initializing.clear();
  }

  void _listenConnectivity() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) {
      final offline = results.every((r) => r == ConnectivityResult.none);

      if (isOffline.value && !offline) {
        isOffline.value = false;
        _recoverCurrentVideo();
        _preCacheUpcoming();
      } else if (!isOffline.value && offline) {
        isOffline.value = true;
      }
    });
  }

  Future<void> _recoverCurrentVideo() async {
    final index = currentIndex.value;
    final existing = _videoControllers[index];

    if (existing == null || existing.value.hasError || !existing.value.isInitialized) {
      _videoControllers[index]?.dispose();
      _videoControllers.remove(index);
      _initializing.remove(index);
      _controllerRevision.value++;
      await _initializeVideo(index);
    }
  }

  Future<void> _fetchReels() async {
    try {
      reels.value = await _reelRepository.fetchReels();

      if (reels.isNotEmpty) {
        final urls = reels.map((r) => r.videoUrl).toList();
        await _videoCacheService.loadExistingCache(urls);

        await _initializeVideo(0);
        isLoading.value = false;
        _playVideo(0);
        _preloadAhead(0);
        _preCacheUpcoming();
      }
    } catch (e) {
      debugPrint('Error fetching reels: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _preloadAhead(int fromIndex) async {
    final futures = <Future<void>>[];
    for (int i = fromIndex + 1;
        i <= (fromIndex + _preloadCount).clamp(0, reels.length - 1);
        i++) {
      if (!_videoControllers.containsKey(i)) {
        futures.add(_initializeVideo(i));
      }
    }
    await Future.wait(futures);
  }

  Future<void> _initializeVideo(int index) async {
    if (index < 0 || index >= reels.length) return;
    if (_videoControllers.containsKey(index)) return;
    if (_initializing.contains(index)) return;

    _initializing.add(index);

    try {
      final url = reels[index].videoUrl;
      final cachedPath = _videoCacheService.getCachedPath(url);

      final VideoPlayerController controller;
      if (cachedPath != null) {
        controller = VideoPlayerController.file(File(cachedPath));
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }

      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(1.0);

      if ((index - currentIndex.value).abs() > _maxAliveDistance) {
        controller.dispose();
        return;
      }

      _videoControllers[index] = controller;
      _controllerRevision.value++;

      if (currentIndex.value == index) {
        controller.play();
        isVideoPlaying.value = true;
      }
    } catch (e) {
      debugPrint('Error initializing video $index: $e');
    } finally {
      _initializing.remove(index);
    }
  }

  void onPageChanged(int index) {
    final previousIndex = currentIndex.value;
    currentIndex.value = index;
    isVideoPlaying.value = true;

    _pauseVideo(previousIndex);
    _disposeDistantVideos(index);
    _ensureCurrentVideo(index);
    _preloadAhead(index);
    _preCacheUpcoming();
  }

  Future<void> _ensureCurrentVideo(int index) async {
    if (_videoControllers.containsKey(index)) {
      _playVideo(index);
    } else {
      await _initializeVideo(index);
    }
  }

  void _playVideo(int index) {
    _videoControllers[index]?.play();
  }

  void _pauseVideo(int index) {
    _videoControllers[index]?.pause();
  }

  void _disposeDistantVideos(int currentIdx) {
    final keysToRemove = <int>[];
    for (final key in _videoControllers.keys) {
      if ((key - currentIdx).abs() > _maxAliveDistance) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _videoControllers[key]?.dispose();
      _videoControllers.remove(key);
    }
    if (keysToRemove.isNotEmpty) _controllerRevision.value++;
  }

  VideoPlayerController? getController(int index) {
    _controllerRevision.value;
    return _videoControllers[index];
  }

  void togglePlayPause(int index) {
    final controller = _videoControllers[index];
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
      isVideoPlaying.value = false;
    } else {
      controller.play();
      isVideoPlaying.value = true;
    }
  }

  void pauseCurrentVideo() {
    _pauseVideo(currentIndex.value);
    isVideoPlaying.value = false;
  }

  void resumeCurrentVideo() {
    _ensureCurrentVideo(currentIndex.value);
    isVideoPlaying.value = true;
  }

  Future<void> refreshReels() async {
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    _initializing.clear();
    _controllerRevision.value++;

    currentIndex.value = 0;
    isLoading.value = true;
    await _fetchReels();
  }

  void _preCacheUpcoming() {
    if (isOffline.value) return;

    final start = currentIndex.value;
    final urls = <String>[];
    for (int i = start; i < reels.length && urls.length < _preCacheCount; i++) {
      urls.add(reels[i].videoUrl);
    }
    _videoCacheService.preCacheVideos(urls, count: _preCacheCount);
  }
}
