import 'package:project_management/features/stages/domain/entities/stage.dart';

abstract class StageRepository {
  Future<List<Stage>> getAllStages();
  Future<void> createStage(Stage stage);
  Future<void> updateStage(Stage stage);
  Future<void> deleteStage(String id);
}