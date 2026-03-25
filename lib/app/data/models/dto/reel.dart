import 'package:cloud_firestore/cloud_firestore.dart';

class Reel {
  final String id;
  final String videoUrl;
  final String username;
  final String caption;
  final int likes;
  final int comments;
  final int shares;
  final int followers;
  final String profilePicUrl;

  Reel({
    required this.id,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    this.comments = 110,
    this.shares = 140,
    this.followers = 0,
    this.profilePicUrl = '',
  });

  factory Reel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reel(
      id: doc.id,
      videoUrl: data['videoUrl'] ?? '',
      username: data['username'] ?? 'Unknown',
      caption: data['caption'] ?? '',
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      shares: data['shares'] ?? 0,
      followers: data['followers'] ?? 0,
      profilePicUrl: data['profilePicUrl'] ?? '',
    );
  }

  factory Reel.fromMap(Map<String, dynamic> map) {
    return Reel(
      id: map['id'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      username: map['username'] ?? 'Unknown',
      caption: map['caption'] ?? '',
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      followers: map['followers'] ?? 0,
      profilePicUrl: map['profilePicUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'username': username,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'followers': followers,
      'profilePicUrl': profilePicUrl,
    };
  }
}
