
import 'package:project_manager/core/network/task/apiclient.dart';
import 'package:project_manager/feature/task/data/models/taskmodel.dart';

class RemoteDataSource {
  final Apiclient apiclient;
  RemoteDataSource(this.apiclient);


  Future<List<TaskModel>> getAllTask() async {
    final data = await this.apiclient.get('/tasks') as List<dynamic>;
    return data.map((e) => TaskModel.fromJson(e as Map<String,dynamic>,e['id'] as int)).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final data = await this.apiclient.post('/tasks', task.toJson());
    return TaskModel.fromJson(data as Map<String, dynamic>,data['id'] as int);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final data = await this.apiclient.post('/tasks/${task.id}', task.toJson());
    return TaskModel.fromJson(data as Map<String, dynamic>,data['id'] as int); 
  }

  Future<void> deleteTask(String id){
    return this.apiclient.delete('/tasks/$id');
  }
}