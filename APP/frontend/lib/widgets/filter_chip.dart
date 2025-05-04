import 'package:flutter/material.dart';

Widget buildFilterChip(String label, {bool isSelected = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (value) {
        // TODO: Implement filtering logic
      },
      selectedColor: const Color(0xFF00C6AE).withOpacity(0.2),
      checkmarkColor: const Color(0xFF00C6AE),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF00C6AE) : Colors.black,
      ),
    ),
  );
}