import 'dart:isolate';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/dto/reel.dart';
import 'reel_repository.dart';

class ReelRepositoryImpl implements ReelRepository {
  final FirebaseFirestore _firestore;

  ReelRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _reelsRef => _firestore.collection('reels');

  @override
  Future<List<Reel>> fetchReels() async {
    final snapshot = await _reelsRef.orderBy('likes', descending: true).get();

    final rawDocs = snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();

    return Isolate.run(() {
      final reels = rawDocs.map((m) => Reel.fromMap(m)).toList();
      reels.shuffle();
      return reels;
    });
  }

  @override
  Future<bool> hasReels() async {
    final snapshot = await _reelsRef.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<void> batchInsertReels(List<Map<String, dynamic>> reels) async {
    final random = Random();
    int written = 0;

    for (int i = 0; i < reels.length; i += 500) {
      final batch = _firestore.batch();
      final end = (i + 500).clamp(0, reels.length);

      for (int j = i; j < end; j++) {
        batch.set(_reelsRef.doc(), {
          ...reels[j],
          'likes': random.nextInt(500000) + 100,
          'comments': random.nextInt(50000) + 10,
          'shares': random.nextInt(5000) + 1,
          'followers': random.nextInt(1000000) + 500,
        });
      }

      await batch.commit();
      written += end - i;
      debugPrint('Committed $written/${reels.length} reels...');
    }
  }
}
