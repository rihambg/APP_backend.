import 'package:flutter/material.dart';

class TrendingTopicsHeader extends StatelessWidget {
  const TrendingTopicsHeader({Key? key}) : super(key: key);
  @override Widget build(BuildContext c) {
    return Row(children: [
      const Icon(Icons.local_fire_department, color: Colors.orange),
      const SizedBox(width:8),
      Text('Trending Topics', style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold, fontSize:16)),
    ]);
  }
}