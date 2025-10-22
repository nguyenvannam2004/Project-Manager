import 'package:project_manager/feature/stages/domain/entities/stage.dart';

class StageModel extends Stage
{
  StageModel(super.id, super.name, super.projectId, super.description, super.status, super.timestamps);
  
  factory StageModel.fromJson(Map<String, dynamic> json)
  {
    return StageModel(
      json['id'],
      json['name'],
      json['projectId'],
      json['description'],
      json['status'],
      json['timestamps'],
    );
  }
  Map<String, dynamic> toJson() =>{
    'id':id,
    'name':name,
    'projectId':projectId,
    'description':description,
    'status':status,
    'timestamps':timestamps,
  };

}