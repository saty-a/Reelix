import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'pexels_api_service.dart';

class PexelsApiServiceImpl implements PexelsApiService {
  final http.Client _client;
  final String _apiKey;

  PexelsApiServiceImpl({
    required String apiKey,
    http.Client? client,
  })  : _apiKey = apiKey,
        _client = client ?? http.Client();

  @override
  Future<List<Map<String, dynamic>>> fetchVideos({
    required List<String> queries,
    int perPage = 80,
    int targetCount = 1000,
  }) async {
    final videos = <Map<String, dynamic>>[];

    for (final query in queries) {
      if (videos.length >= targetCount) break;

      final pagesNeeded = ((targetCount - videos.length) / perPage).ceil();

      for (int page = 1; page <= pagesNeeded; page++) {
        if (videos.length >= targetCount) break;

        debugPrint(
            'Fetching "$query" page $page (${videos.length}/$targetCount)...');

        final response = await _client.get(
          Uri.parse(
            'https://api.pexels.com/videos/search'
            '?query=${Uri.encodeComponent(query)}'
            '&per_page=$perPage'
            '&page=$page',
          ),
          headers: {'Authorization': _apiKey},
        );

        if (response.statusCode != 200) {
          debugPrint(
              'Pexels API error: ${response.statusCode} for "$query" page $page');
          break;
        }

        final data = jsonDecode(response.body);
        final List items = data['videos'] ?? [];
        if (items.isEmpty) break;

        for (final video in items) {
          if (videos.length >= targetCount) break;

          final videoUrl = _pickBestVideoUrl(video['video_files'] ?? []);
          if (videoUrl == null) continue;

          videos.add({
            'videoUrl': videoUrl,
            'username': video['user']?['name'] ?? 'Unknown',
            'caption': video['url']
                    ?.toString()
                    .split('/')
                    .last
                    .replaceAll('-', ' ') ??
                '',
            'profilePicUrl': video['user']?['url'] ?? '',
          });
        }
      }
    }

    return videos;
  }

  String? _pickBestVideoUrl(List files) {
    for (final file in files) {
      if (file['quality'] == 'sd' &&
          file['height'] != null &&
          file['height'] <= 360) {
        return file['link'];
      }
    }
    for (final file in files) {
      if (file['quality'] == 'sd') return file['link'];
    }
    return files.isNotEmpty ? files.last['link'] : null;
  }
}
