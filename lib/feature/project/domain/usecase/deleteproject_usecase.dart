import 'package:project_manager/feature/project/domain/repository/projectrepository.dart';

class DeleteProjectUsecase {
  final ProjectRepository projectRepository;

  DeleteProjectUsecase(this.projectRepository);

  Future<void> call(int id) async {
    return await projectRepository.deleteProject(id);
  }
}