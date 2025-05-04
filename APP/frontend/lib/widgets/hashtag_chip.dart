import 'package:flutter/material.dart';
import '../models/topic_model.dart';

class HashtagChip extends StatelessWidget {
  final Topic topic;
  const HashtagChip(this.topic, {Key? key}) : super(key: key);

  @override Widget build(BuildContext c) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal:12, vertical:6),
      decoration: BoxDecoration(
        color: topic.isActive ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: topic.isActive ? Border.all(color: Colors.blue.shade400) : null,
      ),
      child: Text('#${topic.name}', style: TextStyle(color: topic.isActive ? Colors.blue.shade700 : Colors.black87, fontWeight: topic.isActive ? FontWeight.bold : null)),
    );
  }
}