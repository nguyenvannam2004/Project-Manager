import 'package:project_manager/feature/task/domain/entities/task.dart';

abstract class TaskRepository{
  Future<List<Task>> getAllTask();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
}