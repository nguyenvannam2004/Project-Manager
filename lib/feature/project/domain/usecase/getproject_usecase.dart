import 'package:project_manager/feature/project/domain/entities/project.dart';
import 'package:project_manager/feature/project/domain/repository/projectrepository.dart';

class GetProjectUsecase {
  final ProjectRepository projectRepository;

  GetProjectUsecase(this.projectRepository);
  Future<List<Project>> call() async {
    return await projectRepository.getAllProjects();
  }
}