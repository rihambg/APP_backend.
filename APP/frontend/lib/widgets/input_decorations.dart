import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hint, {IconData? icon}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white.withOpacity(0.2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    errorStyle: const TextStyle(
      color: Colors.redAccent,
      fontSize: 12,
      height: 1.5,
    ),
    suffixIcon: icon != null ? Icon(icon) : null,
  );
}