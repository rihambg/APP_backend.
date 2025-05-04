import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isUrgent;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isUrgent ? Colors.red.shade50 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          isUrgent ? Icons.warning_amber_rounded : Icons.notifications_none,
          color: isUrgent ? Colors.red : Colors.blue,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
        trailing: Text(time, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ),
    );
  }
}