import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';

class StageModel extends Stage {
  StageModel(
    super.id,
    super.name,
    super.projectId,
    super.description,
    super.status,
    super.timestamp,
  );

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      json['id'] as int? ?? 0,
      json['name'] as String? ?? '',
      json['projectId'] as int? ?? 0,
      json['description'] as String? ?? '',
      _parseStatus(json['status']),
      json['timeStamp'] != null
          ? TimeStamp.fromJson(json['timeStamp'] as Map<String, dynamic>)
          : TimeStamp(DateTime.now(), null, null, null),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'projectId': projectId,
        'description': description,
        'status': status.index,
        'timeStamp': timestamps?.toJson(),
      };

  static Status _parseStatus(dynamic value) {
    if (value is int && value >= 0 && value < Status.values.length) {
      return Status.values[value];
    }
    return Status.pending;
  }
}
