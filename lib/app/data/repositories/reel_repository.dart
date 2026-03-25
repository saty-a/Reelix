import '../models/dto/reel.dart';

abstract class ReelRepository {
  Future<List<Reel>> fetchReels();
  Future<bool> hasReels();
  Future<void> batchInsertReels(List<Map<String, dynamic>> reels);
}
