import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/stages/data/models/stageModel.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';
import 'package:flutter/material.dart';

class ApiClient {
  static List<Stage> stage = [];

  ApiClient() {
    if (stage.isNotEmpty) return;
    stage = [
      StageModel(
        1,
        'Design Phase',
        101,
        Text('Initial design of the project'),
        Status.inProgress,
        TimeStamp(DateTime.now(), null, null, null),
      ),
      StageModel(
        2,
        'Development Phase',
        100,
        Text('Core development work'),
        Status.pending,
        TimeStamp(DateTime.now(), null, null, null),
      ),
      StageModel(
        3,
        'Testing Phase',
        104,
        Text('Testing and QA'),
        Status.pending,
        TimeStamp(DateTime.now(), null, null, null),
      ),
    ];
  }

  Future<dynamic> get(String path) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/stages') {
      // Giả lập gọi API server --> lấy dữ liệu
      return stage
          .map(
            (s) => {
              // Dưới đây là các trường từ lớp Stage của bạn
              'id': s.id,
              'name': s.name,
              'projectId': s.projectId,
              'description': s.description.data,
              'status': s.status.toString(),
              'timestamps': {
                'createdAt': s.timestamps.createdAt.toIso8601String(),
                'updatedAt': s.timestamps.updatedAt?.toIso8601String(),
                'startDate': s.timestamps.startDate?.toIso8601String(),
                'endDate': s.timestamps.endDate?.toIso8601String(),
              },
            },
          )
          .toList(); // Dữ liệu stage --> sẽ được map thành StageModel
    }
    throw Exception('Unknown path: $path');
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/stages') {
      final newStage = Stage(
        body['id'] ?? DateTime.now().millisecondsSinceEpoch,
        body['name'],
        body['projectId'],
        Text(body['description']),
        Status.pending,
        TimeStamp(DateTime.now(), null, null, null),
      );

      stage.add(newStage);
      return {
        'id': newStage.id,
        'name': newStage.name,
        'projectId': newStage.projectId,
        'description': newStage.description.data,
        'status': newStage.status.toString(),
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
      final oldStage = stage[index];
      final updatedStage = Stage(
        id, // Giữ nguyên ID
        body['name'] ?? oldStage.name,
        body['projectId'] ?? oldStage.projectId,
        body['description'] != null
            ? Text(body['description'])
            : oldStage.description,
        oldStage.status,
        oldStage.timestamps,
      );

      stage[index] = updatedStage;
      return {
        'id': updatedStage.id,
        'name': updatedStage.name,
        'projectId': updatedStage.projectId,
        'description': updatedStage.description.data,
        'status': updatedStage.status.toString(),
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
