import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';

class TaskModel extends Task
{
  TaskModel(super.id, super.stagedId, super.name, super.description, super.status, super.createBy, super.timeStamp);

  factory TaskModel.fromJson(Map<String, dynamic> json,int id){
    return TaskModel(
      id ,
      json['stagedId'] as int,
      json['name'] as String,
      json['description'] as String,
      json['status'] as Status,
      json['createBy'] as int,
      json['timeStamp'] as TimeStamp
    );
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'stagedId' : stagedId,
    'name' : name,
    'description' : description,
    'status' : status,
    'createBy' : createBy,
    'timeStamp' : timeStamp
  };

}