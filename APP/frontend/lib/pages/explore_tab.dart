import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/post_model.dart';
import '../models/topic_model.dart';
import '../models/video_model.dart';
import '../services/community_service.dart';
import '../widgets/post_item.dart';
import '../widgets/hashtag_chip.dart';
import '../widgets/video_item.dart';

class ExploreTab extends StatefulWidget {
  final String? newPostText;

  const ExploreTab({Key? key, this.newPostText}) : super(key: key);

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  late Future<List<Post>> _posts;
  late Future<List<Topic>> _topics;
  late Future<List<VideoTutorial>> _videos;

  final List<YoutubePlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    _posts = CommunityService.fetchPosts();
    _topics = CommunityService.fetchTopics();
    _videos = CommunityService.fetchVideos();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🔥 Trending Topics",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          /// Posts Section
          FutureBuilder<List<Post>>(
            future: _posts,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text("Failed to load posts.");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No posts found.");
              }
              return Column(
                children: snapshot.data!
                    .map((post) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PostItem(post),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),

          /// Hashtags Section
          const Text(
            "🔖 Browse by Hashtag / Category",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Topic>>(
            future: _topics,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Failed to load hashtags.");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No hashtags found.");
              }
              return Wrap(
                spacing: 8,
                runSpacing: 4,
                children: snapshot.data!.map((topic) => HashtagChip(topic)).toList(),
              );
            },
          ),
          const SizedBox(height: 24),

          /// Videos Section
          const Text(
            "🎥 Videos & Tutorials Section",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<VideoTutorial>>(
            future: _videos,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Failed to load videos.");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No videos available.");
              }

              return Column(
                children: snapshot.data!.map((video) {
                  final videoId = YoutubePlayer.convertUrlToId(video.url) ?? '';
                  final controller = YoutubePlayerController(
                    initialVideoId: videoId,
                    flags: const YoutubePlayerFlags(autoPlay: false),
                  );
                  _videoControllers.add(controller);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: VideoItem(video: video, controller: controller),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
