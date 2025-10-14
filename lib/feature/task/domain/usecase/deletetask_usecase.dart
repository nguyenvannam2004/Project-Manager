import 'package:project_manager/feature/task/domain/repository/taskrepository.dart';

class DeleteTaskUsecase{
  final TaskRepository taskrepository;

  DeleteTaskUsecase(this.taskrepository);
  Future<void> call(int id) async {
    return await taskrepository.deleteTask(id);
  }
}