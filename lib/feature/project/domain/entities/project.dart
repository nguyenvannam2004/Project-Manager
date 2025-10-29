
import '../../../../core/entities/status.dart';
import '../../../../core/entities/timestamp.dart';

class Project {
  final int id;
  final String name;
  final String description;
  final Status status;
  final int createdBy;
  final TimeStamp timestamp;

  Project(this.id, this.name, this.description, this.status, this.createdBy, this.timestamp);

}