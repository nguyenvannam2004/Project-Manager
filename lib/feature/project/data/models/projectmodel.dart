import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel(
    super.id,
    super.name,
    super.description,
    super.status,
    super.createdBy,
    super.timestamp,
  );

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      json['id'] as int,
      json['name'] as String,
      json['description'] as String,
      Status.values[json['status'] as int],
      json['createdBy'] != null ? json['createdBy'] as int : 0,
      json['timeStamp'] != null
          ? TimeStamp.fromJson(json['timeStamp'] as Map<String, dynamic>)
          : TimeStamp(DateTime.now(), null, null, null),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'status': status.index,
        'createdBy': createdBy,
        'timeStamp': timestamp?.toJson(),
      };
}
