
import 'package:project_manager/core/network/stages/apiclient.dart';
import 'package:project_manager/feature/stages/data/models/stageModel.dart';

class RemoteDatasource 
{
  final ApiClient apiClient;

  RemoteDatasource(this.apiClient);

  Future<List<StageModel>> getAllStages() async {
    // Implementation to fetch stages from remote API
    final data = this.apiClient.get('/stages') as List<dynamic>;
    return data.map((e) => StageModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<StageModel> createStage(StageModel stage) async {
    final data = await apiClient.post('/stages', stage.toJson());
    return StageModel.fromJson(data as Map<String, dynamic>);
  }
  Future<StageModel> updateStage(StageModel stage) async {
    final data = await apiClient.put('/stages/${stage.id}', stage.toJson());
    return StageModel.fromJson(data);
  }

  Future<void> deleteStage(String id) async {
    await apiClient.delete('/stages/$id');
  }
}