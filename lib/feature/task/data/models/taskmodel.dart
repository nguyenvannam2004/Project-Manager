import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel(
    super.id,
    super.stagedId,
    super.name,
    super.description,
    super.status,
    super.createBy,
    super.timeStamp,
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      json['id'] as int,
      json['stagedId'] as int,
      json['name'] as String,
      json['description'] as String,
      Status.values[json['status'] as int],
      json['createBy'] as int,
      TimeStamp.fromJson(json['timeStamp'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stagedId': stagedId,
        'name': name,
        'description': description,
        'status': status.index,
        'createBy': createBy,
        'timeStamp': timeStamp.toJson(),
      };
}
