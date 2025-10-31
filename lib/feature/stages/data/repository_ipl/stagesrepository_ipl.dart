import 'package:project_manager/feature/stages/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/stages/data/models/stageModel.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';
import 'package:project_manager/feature/stages/domain/repository/stage_repository.dart';

class StagesRepositoryIpl extends StageRepository
{
  final RemoteDatasourceStage remoteDatasource;

  StagesRepositoryIpl(this.remoteDatasource);
  
  @override
  Future<void> createStage(Stage stage) {
    final data = StageModel(stage.id, stage.name, stage.projectId, stage.description, stage.status, stage.timestamps);
    return this.remoteDatasource.createStage(data);
  }

  @override
  Future<void> deleteStage(String id) {
    return this.remoteDatasource.deleteStage(id);
  }

  @override
  Future<List<Stage>> getAllStages() {
    return this.remoteDatasource.getAllStages();
  }

  @override
  Future<void> updateStage(Stage stage) {
    final data = StageModel(stage.id, stage.name, stage.projectId, stage.description, stage.status, stage.timestamps);
    return this.remoteDatasource.updateStage(data);
  }
  
  

}