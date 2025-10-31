
import 'package:project_manager/feature/stages/domain/entities/stage.dart';

abstract class StageRepository {
  Future<List<Stage>> getAllStages();
  Future<void> createStage(Stage stage);
  Future<void> updateStage(Stage stage);
  Future<void> deleteStage(String id);

}