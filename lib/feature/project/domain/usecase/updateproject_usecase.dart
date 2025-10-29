
import '../../../../core/entities/status.dart';
import '../../../../core/entities/timestamp.dart';
import '../entities/project.dart';
import '../repository/projectrepository.dart';

class UpdateProjectUsecase {
  final ProjectRepository projectRepository;

  UpdateProjectUsecase(this.projectRepository);

  Future<void> call(
    int id,
    String name,
    String description,
    Status status,
    int createdBy,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final timestamp = TimeStamp(createdAt, updatedAt, startDate, endDate);
    final data = Project(id, name, description, status, createdBy, timestamp);
    return await this.projectRepository.updateProject(data);
  }
}