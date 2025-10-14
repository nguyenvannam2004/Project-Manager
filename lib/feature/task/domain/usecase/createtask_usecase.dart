import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';
import 'package:project_manager/feature/task/domain/repository/taskrepository.dart';

class CreateTaskUsecase {
  final TaskRepository taskrepository;

  CreateTaskUsecase(this.taskrepository);
  Future<void> call(int id, int stagedId, String name, String description, Status status, int createBy, DateTime createdAt, DateTime updatedAt, DateTime startDate, DateTime endDate) async {
    final timeStamp = TimeStamp(createdAt, updatedAt, startDate, endDate);
    final data = Task(id, stagedId, name, description, status, createBy, timeStamp);
    return await taskrepository.createTask(data);
  }
}