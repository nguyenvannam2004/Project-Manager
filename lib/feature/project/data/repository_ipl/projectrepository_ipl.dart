import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/project/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/project/data/models/projectmodel.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';
import 'package:project_manager/feature/project/domain/repository/projectrepository.dart';

class ProjectRepositoryIpl extends ProjectRepository {
  final RemoteDataSourceProject remotedatasource;

  ProjectRepositoryIpl(this.remotedatasource);

  @override
  Future<List<Project>> getAllProjects() async {
    final data = await remotedatasource.getAllProject();
    return data; 
  }

  @override
  Future<ProjectModel> createProject(Project project) async {
    final data = ProjectModel(
      project.id,
      project.name,
      project.description,
      project.status,
      project.createdBy,
      project.timestamp,
    );
    return await remotedatasource.createProject(data);
  }

  @override
Future<ProjectModel> updateProject(Project project) async {
  final now = DateTime.now();
  final updatedProject = ProjectModel(
    project.id,
    project.name,
    project.description,
    project.status,
    project.createdBy,
    project.timestamp != null
        ? project.timestamp.copyWith(
            updatedAt: now,
            startDate: project.timestamp.startDate ?? now,
            endDate: project.timestamp.endDate ?? now.add(Duration(days: 7)),
          )
        : TimeStamp(now, now, now, now.add(Duration(days: 7))),
  );

  return await remotedatasource.updateProject(updatedProject);
}


  @override
  Future<void> deleteProject(int id) async {
    await remotedatasource.deleteProject(id.toString());
  }
}
