import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';

class ProjectUtils {
  static Color statusColor(Status status) {
    switch (status) {
      case Status.pending:     return const Color(0xFFF59E0B);
      case Status.inProgress:  return const Color(0xFF3B82F6);
      case Status.completed:   return const Color(0xFF10B981);
      case Status.cancelled:   return const Color(0xFFEF4444);
      default:                 return const Color(0xFF6B7280);
    }
  }

  static IconData statusIcon(Status status) {
    switch (status) {
      case Status.inProgress: return Icons.check_circle;
      case Status.pending:    return Icons.watch_later_outlined;
      case Status.completed:  return Icons.check_circle;
      case Status.cancelled:  return Icons.cancel_outlined;
      default:                return Icons.help_outline;
    }
  }

  static String statusText(Status status) {
    switch (status) {
      case Status.inProgress: return 'Đang làm';
      case Status.pending:    return 'Chờ';
      case Status.completed:  return 'Hoàn thành';
      case Status.cancelled:  return 'Đã hủy';
      default:                return 'Không rõ';
    }
  }

  static String formatDateRange(DateTime? start, DateTime? end) {
    final f = DateFormat('dd/MM/yyyy');
    return '${start != null ? f.format(start) : 'N/A'} - ${end != null ? f.format(end) : 'N/A'}';
  }
}