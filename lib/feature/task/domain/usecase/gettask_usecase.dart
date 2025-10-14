import 'package:project_manager/feature/task/domain/entities/task.dart';
import 'package:project_manager/feature/task/domain/repository/taskrepository.dart';

class GetTaskUsecase{
  final TaskRepository taskrepository;

  GetTaskUsecase(this.taskrepository);
  Future <List<Task>> call() async{
    return await taskrepository.getAllTask();
  }
}