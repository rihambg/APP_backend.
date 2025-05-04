import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem(this.post, {Key? key}) : super(key: key);

  @override Widget build(BuildContext c) {
    return Container(
      padding: const EdgeInsets.only(bottom:16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const CircleAvatar(child: Icon(Icons.person, size:16)),
            const SizedBox(width:8),
            Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          Text(post.timeAgo, style: TextStyle(color: Colors.grey.shade600, fontSize:12)),
        ]),
        Padding(padding: const EdgeInsets.symmetric(vertical:8.0), child: Text(post.content)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Icon(Icons.chat_bubble_outline, size:16, color: Colors.grey),
            const SizedBox(width:4),
            Text('${post.comments} Comments', style: TextStyle(color: Colors.grey.shade600, fontSize:12)),
          ]),
          Text('Replied to by ${post.repliedBy}', style: TextStyle(color: Colors.grey.shade600, fontSize:12)),
        ]),
      ]),
    );
  }
}