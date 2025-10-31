import 'package:project_manager/core/network/auth/IApiclient.dart';
import 'package:project_manager/feature/project/data/models/projectmodel.dart';
import 'dart:convert';

class RemoteDataSourceProject {
  final IApiClient apiclient;
  RemoteDataSourceProject(this.apiclient);

  Future<List<ProjectModel>> getAllProject() async {
    final data = await apiclient.get('/api/Projects');

    final List<dynamic> decoded =
        data is String ? json.decode(data) as List<dynamic> : data as List<dynamic>;

    return decoded.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ProjectModel> createProject(ProjectModel project) async {
    final requestData = project.toJson();
    requestData.remove('id'); // backend tự sinh id

    final data = await apiclient.post('/api/Projects', requestData);

    final Map<String, dynamic> jsonData =
        data is String ? json.decode(data) as Map<String, dynamic> : data as Map<String, dynamic>;

    return ProjectModel.fromJson(jsonData);
  }

  Future<ProjectModel> updateProject(ProjectModel project) async {
    try {
      final data = await apiclient.put('/api/Projects/${project.id}', project.toJson());
      if (data == null || (data is String && data.isEmpty)) {
        return project;
      }

      final Map<String, dynamic> jsonData =
          data is String ? json.decode(data) as Map<String, dynamic> : data as Map<String, dynamic>;

      return ProjectModel.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    await apiclient.delete('/api/Projects/$id');
  }
}
