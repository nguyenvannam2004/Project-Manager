import 'package:project_manager/feature/project/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/project/data/models/projectmodel.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';
import 'package:project_manager/feature/project/domain/repository/projectrepository.dart';

class ProjectRepositoryIpl extends ProjectRepository {
  final RemoteDataSource remotedatasource;

  ProjectRepositoryIpl(this.remotedatasource);
  @override
  Future<void> createProject(Project project) {
    final data = ProjectModel(
      project.id,
      project.name,
      project.description,
      project.status,
      project.createdBy,
      project.timestamp,
    );
    return this.remotedatasource.createProject(data).then((_) => null);
  }

  @override
  Future<void> deleteProject(int id) {
    return this.remotedatasource.deleteProject(id.toString());
  }

  @override
  Future<List<Project>> getAllProjects() {
    return this.remotedatasource.getAllProject();
  }

  @override
  Future<void> updateProject(Project project) {
    final data = ProjectModel(
      project.id,
      project.name,
      project.description,
      project.status,
      project.createdBy,
      project.timestamp,
    );
    return this.remotedatasource.updateProject(data).then((_) => null);
  }
}
