
import 'package:project_manager/feature/task/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/task/data/models/taskmodel.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';
import 'package:project_manager/feature/task/domain/repository/taskrepository.dart';

class TaskRepositoryIpl extends TaskRepository{

  final RemoteDataSourceTask remotedatasource;

  TaskRepositoryIpl(this.remotedatasource);
  @override
  Future<void> createTask(Task task) {
    final data = TaskModel(task.id, task.stagedId, task.name, task.description, task.status, task.createBy, task.timeStamp);
    return this.remotedatasource.createTask(data);
  }

  @override
  Future<void> deleteTask(int id) {
    return this.remotedatasource.deleteTask(id);
  }

  @override
  Future<List<Task>> getAllTask() {
    return this.remotedatasource.getAllTask();
  }

  @override
  Future<void> updateTask(Task task) {
    final data = TaskModel(task.id, task.stagedId, task.name, task.description, task.status, task.createBy, task.timeStamp);
    return this.remotedatasource.updateTask(data);
  }
}