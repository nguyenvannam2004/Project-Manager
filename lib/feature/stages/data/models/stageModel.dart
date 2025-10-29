import 'package:flutter/material.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';

class StageModel extends Stage {
  StageModel(
    super.id,
    super.name,
    super.projectId,
    super.description,
    super.status,
    super.timestamps,
  );

  factory StageModel.fromJson(Map<String, dynamic> json) {
    // Xử lý cấu trúc JSON từ ApiClient
    final timestampsData = json['timestamps'] as Map<String, dynamic>? ?? {};
    
    return StageModel(
      json['id'] as int? ?? 0,
      json['name'] as String? ?? '',
      json['projectId'] as int? ?? 0,
      Text(json['description'] as String? ?? ''),
      _parseStatus(json['status'] as String? ?? 'pending'),
      TimeStamp(
        timestampsData['createdAt'] != null
            ? DateTime.parse(timestampsData['createdAt'] as String)
            : DateTime.now(),
        timestampsData['updatedAt'] != null
            ? DateTime.parse(timestampsData['updatedAt'] as String)
            : null,
        timestampsData['startDate'] != null
            ? DateTime.parse(timestampsData['startDate'] as String)
            : null,
        timestampsData['endDate'] != null
            ? DateTime.parse(timestampsData['endDate'] as String)
            : null,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'projectId': projectId,
        'description': description.data ?? '',
        'status': status.toString().split('.').last,
        'timestamps': {
          'createdAt': timestamps.createdAt.toIso8601String(),
          'updatedAt': timestamps.updatedAt?.toIso8601String(),
          'startDate': timestamps.startDate?.toIso8601String(),
          'endDate': timestamps.endDate?.toIso8601String(),
        },
      };

  // Helper method to parse Status from String
  static Status _parseStatus(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'pending':
        return Status.pending;
      case 'inprogress':
      case 'in_progress':
        return Status.inProgress;
      case 'completed':
        return Status.completed;
      case 'cancelled':
        return Status.cancelled;
      default:
        return Status.pending;
    }
  }
}