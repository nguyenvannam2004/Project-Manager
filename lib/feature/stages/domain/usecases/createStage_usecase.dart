import 'package:flutter/widgets.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';
import 'package:project_manager/feature/stages/domain/repository/stage_repository.dart';

class CreateStageUsecase {
  final StageRepository stageRepository;

  CreateStageUsecase(this.stageRepository);
  Future<void> call(
    int id, 
    String name, 
    int projectId, 
    Text description, 
    DateTime start_date, 
    DateTime end_date,
    Status status,
    DateTime create_at,
    DateTime updated_at

    ) async {
    final TimeStamp timestamps = TimeStamp(create_at, updated_at, start_date, end_date);
    final data = Stage(id, name, projectId, description, status, timestamps);
    return await stageRepository.createStage(data);
  }
}