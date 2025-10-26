import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';

class ProjectModel extends Project
{
  ProjectModel(super.id, super.name, super.description, super.status, super.createBy, super.timeStamp);

  factory ProjectModel.fromJson(Map<String, dynamic> json,int id){
    return  ProjectModel(
      id ,
      json['name'] as String,
      json['description'] as String, 
      json['status'] as Status,
      json['createBy'] as int,
      json['timeStamp'] as TimeStamp
    );
  }

  Map<String,dynamic> toJson() => {
    'name' : name,
    'description' : description,
    'status' : status,
    'createBy' : createdBy,
    'timeStamp' : timestamp
  };

}