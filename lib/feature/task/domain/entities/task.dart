import 'package:equatable/equatable.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';

class Task extends Equatable{
  final int id;
  final int stagedId;
  final String name;
  final String description;
  final Status status;
  final int createBy;
  final TimeStamp timeStamp;

  Task(this.id, this.stagedId, this.name, this.description, this.status, this.createBy, this.timeStamp);
  
  @override
  List<Object?> get props => [id, stagedId, name, description, status, createBy, timeStamp];
}