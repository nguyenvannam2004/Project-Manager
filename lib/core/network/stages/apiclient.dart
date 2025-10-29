import 'package:flutter/material.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/stages/data/models/stageModel.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';

class ApiClient {
  static List<Stage> stage = [];
  Status _parseStatus(String statusString) {
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

  ApiClient() {
    if (stage.isNotEmpty) return;
    stage = [
      StageModel(
        1,
        'Design Phase',
        101,
        Text('Initial design of the project'),
        Status.inProgress,
        TimeStamp(DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now()),
      ),
      StageModel(
        2,
        'Development Phase',
        100,
        Text('Core development work'),
        Status.pending,
        TimeStamp(DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now()),
      ),
      StageModel(
        3,
        'Testing Phase',
        104,
        Text('Testing and QA'),
        Status.pending,
        TimeStamp(DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now()),
      ),
    ];
  }

  Future<dynamic> get(String path) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/stages') {
      return stage
          .map(
            (s) => {
              'id': s.id,
              'name': s.name,
              'projectId': s.projectId,
              'description': s.description.data ?? '',
              'status': s.status.toString().split('.').last,
              'timestamps': {
                'createdAt': s.timestamps.createdAt.toIso8601String(),
                'updatedAt': s.timestamps.updatedAt?.toIso8601String(),
                'startDate': s.timestamps.startDate?.toIso8601String(),
                'endDate': s.timestamps.endDate?.toIso8601String(),
              },
            },
          )
          .toList(); 
    }
    throw Exception('Unknown path: $path');
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/stages') {
      final timestampsMap = body['timestamps'] as Map<String, dynamic>? ?? {};
      final newStage = Stage(
        body['id'] as int,
        body['name'] as String,
        body['projectId'] as int,
        Text(body['description'] as String? ?? ''),
        _parseStatus(body['status'] as String? ?? 'pending'),
        TimeStamp(
          timestampsMap['createdAt'] != null
              ? DateTime.parse(timestampsMap['createdAt'] as String)
              : DateTime.now(),
          timestampsMap['updatedAt'] != null
              ? DateTime.parse(timestampsMap['updatedAt'] as String)
              : null,
          timestampsMap['startDate'] != null
              ? DateTime.parse(timestampsMap['startDate'] as String)
              : null,
          timestampsMap['endDate'] != null
              ? DateTime.parse(timestampsMap['endDate'] as String)
              : null,
        ),
      );

      stage.add(newStage);
      return {
        'id': newStage.id,
        'name': newStage.name,
        'projectId': newStage.projectId,
        'description': newStage.description.data ?? '',
        'status': newStage.status.toString().split('.').last,
        'timestamps': {
          'createdAt': newStage.timestamps.createdAt.toIso8601String(),
          'updatedAt': newStage.timestamps.updatedAt?.toIso8601String(),
          'startDate': newStage.timestamps.startDate?.toIso8601String(),
          'endDate': newStage.timestamps.endDate?.toIso8601String(),
        },
      };
    }
    throw Exception('Unknown POST path: $path');
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 400));

    if (path.startsWith('/stages/')) {
      final idString = path.split('/').last;
      final id = int.tryParse(idString);

      if (id == null) {
        throw Exception('Invalid ID format in path');
      }
      final index = stage.indexWhere((s) => s.id == id);
      if (index == -1) {
        throw Exception('Stage not found');
      }
      final timestampsMap = body['timestamps'] as Map<String, dynamic>? ?? {};
      final updatedStage = Stage(
        id, // Giữ nguyên ID
        body['name'] as String,
        body['projectId'] as int,
        Text(body['description'] as String? ?? ''),
        _parseStatus(body['status'] as String? ?? 'pending'),
        TimeStamp(
          timestampsMap['createdAt'] != null
              ? DateTime.parse(timestampsMap['createdAt'] as String)
              : DateTime.now(),
          timestampsMap['updatedAt'] != null
              ? DateTime.parse(timestampsMap['updatedAt'] as String)
              : null,
          timestampsMap['startDate'] != null
              ? DateTime.parse(timestampsMap['startDate'] as String)
              : null,
          timestampsMap['endDate'] != null
              ? DateTime.parse(timestampsMap['endDate'] as String)
              : null,
        ),
      );

      stage[index] = updatedStage;
      return {
        'id': updatedStage.id,
        'name': updatedStage.name,
        'projectId': updatedStage.projectId,
        'description': updatedStage.description.data ?? '',
        'status': updatedStage.status.toString().split('.').last,
        'timestamps': {
          'createdAt': updatedStage.timestamps.createdAt.toIso8601String(),
          'updatedAt': updatedStage.timestamps.updatedAt?.toIso8601String(),
          'startDate': updatedStage.timestamps.startDate?.toIso8601String(),
          'endDate': updatedStage.timestamps.endDate?.toIso8601String(),
        },
      };
    }
    throw Exception('Unknown PUT path: $path');
  }

  Future<void> delete(String path) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/stages/')) {
      final idString = path.split('/').last;
      final id = int.tryParse(idString);

      if (id == null) {
        throw Exception('Invalid ID format in path');
      }
      stage.removeWhere((s) => s.id == id);
      return;
    }

    throw Exception('Unknown DELETE path: $path');
  }
}
