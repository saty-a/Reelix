abstract class PexelsApiService {
  Future<List<Map<String, dynamic>>> fetchVideos({
    required List<String> queries,
    int perPage = 80,
    int targetCount = 1000,
  });
}
