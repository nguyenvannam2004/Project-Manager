import 'dart:convert';
import 'package:project_manager/core/network/auth/IApiclient.dart';
import 'package:project_manager/feature/task/data/models/taskmodel.dart';

class RemoteDataSourceTask {
  final IApiClient apiClient;
  RemoteDataSourceTask(this.apiClient);

  Future<List<TaskModel>> getAllTask() async {
    final data = await apiClient.get('/api/Tasks');
    final List<dynamic> listData = data is String ? json.decode(data) : data;
    return listData
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final data = await apiClient.post('/api/Tasks', task.toJson());
    if (data == null || (data is String && data.trim().isEmpty)) {
      print('Empty response on create task');
      return task;
    }
    final Map<String, dynamic> decoded =
        data is String ? json.decode(data) : data;
    return TaskModel.fromJson(decoded);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final data =
          await apiClient.put('/api/Tasks/${task.id}', task.toJson());

      if (data == null || (data is String && data.trim().isEmpty)) {
        print('Empty response on update task');
        return task;
      }

      final Map<String, dynamic> decoded =
          data is String ? json.decode(data) : data;

      return TaskModel.fromJson(decoded);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    await apiClient.delete('/api/Tasks/$id');
  }
}
