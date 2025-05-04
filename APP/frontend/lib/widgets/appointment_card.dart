import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String purpose;
  final String time;
  final String initials;
  final Color color;
  final bool isHighPriority;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.purpose,
    required this.time,
    required this.initials,
    required this.color,
    this.isHighPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(initials, style: TextStyle(color: color)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(purpose),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (isHighPriority)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.priority_high, color: Colors.red, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}