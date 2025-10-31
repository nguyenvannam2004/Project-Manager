// lib/common/widgets/error_view.dart
import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String message;
  const AppError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.error_outline_rounded, size: 40, color: Color(0xFFEF4444))),
          const SizedBox(height: 20),
          Text("Lỗi: $message", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF374151)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}