// lib/common/widgets/gradient_fab.dart
import 'package:flutter/material.dart';

class GradientFAB extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GradientFAB({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.add_rounded, size: 22),
      ),
    );
  }
}