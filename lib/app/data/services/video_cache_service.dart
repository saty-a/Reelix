import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VideoCacheService {
  final Map<String, String> _cache = {};
  final Set<String> _downloading = {};
  String? _cacheDir;

  Future<String> get _cachePath async {
    if (_cacheDir != null) return _cacheDir!;
    final dir = await getApplicationCacheDirectory();
    final videoDir = Directory('${dir.path}/video_cache');
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    _cacheDir = videoDir.path;
    return _cacheDir!;
  }

  String? getCachedPath(String videoUrl) => _cache[videoUrl];

  bool isCached(String videoUrl) => _cache.containsKey(videoUrl);

  Future<String?> cacheVideo(String videoUrl) async {
    if (_cache.containsKey(videoUrl)) return _cache[videoUrl];
    if (_downloading.contains(videoUrl)) return null;

    _downloading.add(videoUrl);

    try {
      final dir = await _cachePath;
      final fileName = videoUrl.hashCode.toRadixString(36);
      final filePath = '$dir/$fileName.mp4';

      final file = File(filePath);
      if (await file.exists()) {
        _cache[videoUrl] = filePath;
        return filePath;
      }

      final response = await http.get(Uri.parse(videoUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        _cache[videoUrl] = filePath;
        return filePath;
      }
    } catch (e) {
      debugPrint('Cache download failed: $e');
    } finally {
      _downloading.remove(videoUrl);
    }
    return null;
  }

  Future<void> preCacheVideos(List<String> videoUrls, {int count = 5}) async {
    final toCache = videoUrls
        .where((url) => !_cache.containsKey(url) && !_downloading.contains(url))
        .take(count)
        .toList();

    await Future.wait(toCache.map((url) => cacheVideo(url)));
  }

  Future<void> loadExistingCache(List<String> knownUrls) async {
    final dir = await _cachePath;
    for (final url in knownUrls) {
      final fileName = url.hashCode.toRadixString(36);
      final file = File('$dir/$fileName.mp4');
      if (await file.exists()) {
        _cache[url] = file.path;
      }
    }
    debugPrint('Loaded ${_cache.length} cached videos from disk');
  }
}
