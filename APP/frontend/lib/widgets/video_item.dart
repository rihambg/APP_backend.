import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video_model.dart';

class VideoItem extends StatelessWidget {
  final VideoTutorial video;
  final YoutubePlayerController controller;
  const VideoItem({required this.video, required this.controller, super.key});

  @override
  Widget build(BuildContext c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Icon(Icons.play_arrow),
        const SizedBox(width: 8),
        Expanded(
            child: Text(video.title,
                style: const TextStyle(fontWeight: FontWeight.bold))),
      ]),
      const SizedBox(height: 8),
      Container(
        height: 180,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.black),
        child: YoutubePlayer(
            controller: controller, showVideoProgressIndicator: true),
      ),
      const SizedBox(height: 8),
      Row(children: [
        Text('Duration: ${video.duration}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const Text(' | '),
        Text(video.author,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ]),
    ]);
  }
}
