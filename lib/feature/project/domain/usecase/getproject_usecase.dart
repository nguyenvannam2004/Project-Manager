
import '../entities/project.dart';
import '../repository/projectrepository.dart';

class GetProjectUsecase {
  final ProjectRepository projectRepository;

  GetProjectUsecase(this.projectRepository);
  Future<List<Project>> call() async {
    return await projectRepository.getAllProjects();
  }
}