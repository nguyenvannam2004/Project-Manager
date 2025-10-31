import 'dart:convert';
import 'package:project_manager/core/network/auth/IApiclient.dart';
import 'package:project_manager/feature/stages/data/models/stageModel.dart';

class RemoteDatasourceStage {
  final IApiClient apiClient;

  RemoteDatasourceStage(this.apiClient);

  Future<List<StageModel>> getAllStages() async {
    final data = await apiClient.get('/api/Stages');
    final List<dynamic> listData = data is String ? json.decode(data) : data;
    return listData
        .map((e) => StageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<StageModel> createStage(StageModel stage) async {
    final data = await apiClient.post('/api/Stages', stage.toJson());
    final Map<String, dynamic> decoded =
        data is String ? json.decode(data) : data;
    return StageModel.fromJson(decoded);
  }

  Future<StageModel> updateStage(StageModel stage) async {
    try {
      final data = await apiClient.put('/api/Stages/${stage.id}', stage.toJson());
      if (data == null || (data is String && data.trim().isEmpty)) {
        print(' Server returned empty response after updating stage');
        return stage;
      }
      final Map<String, dynamic> decoded =
          data is String ? json.decode(data) : data;
      return StageModel.fromJson(decoded);
    } catch (e) {
      throw Exception('Failed to update stage: $e');
    }
  }


  Future<void> deleteStage(String id) async {
    await apiClient.delete('/api/Stages/$id');
  }
}
