import 'package:project_manager/feature/project/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getAllProjects();
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(int id);
}