
import 'package:project_manager/feature/stages/domain/repository/stage_repository.dart';

class DeletestageUsecase {
  final StageRepository repository;

  DeletestageUsecase(this.repository);
  Future<void> call(String id) async {
    return await this.repository.deleteStage(id);
  }
}