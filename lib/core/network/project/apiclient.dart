import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';

class Apiclient {
  static List<Project> project = [];

  Apiclient() {
    if (project.isNotEmpty) return;
    project = [
      Project(
        01,
        'NguyenVanA',
        'loptruong',
        Status.completed,
        01,
        TimeStamp(
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
        ),
      ),
      Project(
        02,
        'NguyenVanB',
        'loppho',
        Status.inProgress,
        02,
        TimeStamp(
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
        ),
      ),
      Project(
        03,
        'NguyenVanC',
        'sinhvien',
        Status.pending,
        03,
        TimeStamp(
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
        ),
      ),
    ];
  }

  Future<dynamic> get(String path) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/project') {
      return project
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'description': p.description,
              'status': p.status,
              'createBy': p.createdBy,
              'timeStamp': p.timestamp,
            },
          )
          .toList();
    }
    throw Exception('Unknown path: $path');
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/project') {
      // determine id (allow caller to supply or auto-generate)
      final dynamic rawId = body['id'];
      final int id = rawId is int
          ? rawId
          : (rawId is String
                ? int.tryParse(rawId) ?? (project.length + 1)
                : (project.length + 1));
      final newProject = Project(
        id,
        body['name'],
        body['description'],
        body['status'],
        body['createBy'] ?? body['createdBy'],
        body['timeStamp'] ?? body['timestamp'],
      );
      project.add(newProject);
      return {
        'id': newProject.id,
        'name': newProject.name,
        'description': newProject.description,
        'status': newProject.status,
        'createBy': newProject.createdBy,
        'timeStamp': newProject.timestamp,
      };
    }
    throw Exception('Unknown POST path: $path');
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/project/')) {
      final idStr = path.split('/').last;
      final int? id = int.tryParse(idStr);
      if (id == null) throw Exception('Invalid id: $idStr');
      final index = project.indexWhere((p) => p.id == id);
      if (index == -1) throw Exception('Project not found');

      final updated = Project(
        id,
        body['name'],
        body['description'],
        body['status'],
        body['createBy'] ?? body['createdBy'],
        body['timeStamp'] ?? body['timestamp'],
      );
      project[index] = updated;
      return {
        'id': updated.id,
        'name': updated.name,
        'description': updated.description,
        'status': updated.status,
        'createBy': updated.createdBy,
        'timeStamp': updated.timestamp,
      };
    }
    throw Exception('Unknown PUT path: $path');
  }

  Future<void> delete(String path) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/project/')) {
      final idStr = path.split('/').last;
      final int? id = int.tryParse(idStr);
      if (id == null) throw Exception('Invalid id: $idStr');
      project.removeWhere((p) => p.id == id);
      return;
    }
    throw Exception('Unknown DELETE path: $path');
  }
}
