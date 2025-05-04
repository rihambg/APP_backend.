import '../models/post_model.dart';
import '../models/topic_model.dart';
import '../models/video_model.dart';
import '../models/challenge_model.dart';
import '../models/group_model.dart';

class CommunityService {
  // In‑memory store of posts
  static final List<Post> _posts = [
    Post(
      username: 'Mira_12',
      timeAgo: '3 mins ago',
      content: '…morning glucose spikes…',
      comments: 22,
      repliedBy: 'Dr. Randi',
    ),
    Post(
      username: 'LambdaClub',
      timeAgo: '1 day ago',
      content: '…insulin pen vs pump…',
      comments: 89,
      repliedBy: 'Dr. StefanPablo',
    ),
    Post(
      username: 'MarvelFanshine',
      timeAgo: '3 days ago',
      content: '…craving everything sweet…',
      comments: 123,
      repliedBy: 'Dr. Fayenne',
    ),
  ];

  /// Returns a fresh copy of the current post list.
  static Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Post>.from(_posts);
  }

  /// Inserts a new post at the top of the feed.
  static void addPost(Post post) {
    _posts.insert(0, post);
  }

  static Future<List<Topic>> fetchTopics() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      Topic('MealIdeas'),
      Topic('Insulin', isActive: true),
      Topic('MentalHealth'),
      Topic('Exercise'),
    ];
  }

  static Future<List<VideoTutorial>> fetchVideos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      VideoTutorial(
        id: 'abcdefghijk',
        title: 'How to Inject Insulin Safely',
        duration: '11 min',
        author: 'Dr. LindseyDoe',
      ),
    ];
  }

  static Future<List<Challenge>> fetchChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Challenge(
        id: 1,
        title: '10k Steps Challenge',
        description: 'Walk 10,000 steps every day for a week.',
        imageUrl: 'https://via.placeholder.com/200x100.png?text=10k+Steps',
      ),
      Challenge(
        id: 2,
        title: 'No Sugar Week',
        description: 'Avoid added sugars for 7 days straight.',
        imageUrl: 'https://via.placeholder.com/200x100.png?text=No+Sugar',
      ),
      Challenge(
        id: 3,
        title: 'Hydration Goal',
        description: 'Drink at least 2 liters of water daily.',
        imageUrl: 'https://via.placeholder.com/200x100.png?text=Hydration',
      ),
    ];
  }

  static Future<List<Group>> fetchAvailableGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Group(
        title: 'Type 1 Warriors',
        imageUrl: 'https://via.placeholder.com/200x100.png?text=Type+1+Warriors',
        membersCount: 120,
        isJoined: false,
      ),
      Group(
        title: 'Arabic T2D Support',
        imageUrl: 'https://via.placeholder.com/200x100.png?text=Arabic+T2D',
        membersCount: 80,
        isJoined: false,
      ),
    ];
  }

  static Future<List<Group>> fetchUserGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Group(
        title: 'Arabic T2D Support',
        imageUrl: 'https://via.placeholder.com/200x100.png?text=Arabic+T2D',
        membersCount: 80,
        isJoined: true,
      ),
    ];
  }
}