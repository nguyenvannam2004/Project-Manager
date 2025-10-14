import 'package:project_management/features/stages/domain/entities/stage.dart';
import 'package:project_management/features/stages/domain/repository/stage_repository.dart';

class GetStageUsecase {
  final StageRepository stageRepository;

  GetStageUsecase(this.stageRepository);
  Future<List<Stage>> call() async {
    return await stageRepository.getAllStages();
  }
}