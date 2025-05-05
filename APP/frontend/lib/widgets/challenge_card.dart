import 'package:flutter/material.dart';
import '../models/challenge_model.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  const ChallengeCard({required this.challenge, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue.shade50,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.network(challenge.imageUrl, height: 100, fit: BoxFit.cover),
        const SizedBox(height: 8),
        Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(challenge.description, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}