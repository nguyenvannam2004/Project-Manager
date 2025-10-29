import 'package:equatable/equatable.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadTasksEvent extends TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final int id;
  final int stagedId;
  final String name;
  final String description;
  final Status status;
  final int createBy;
  final TimeStamp timeStamp;

  CreateTaskEvent(this.id, this.stagedId, this.name, this.description, this.status, this.createBy, this.timeStamp);

  @override
  List<Object?> get props => [id, stagedId, name, description, status, createBy, timeStamp];
}

class UpdateTaskEvent extends TaskEvent {
  final int id;
  final int stagedId;
  final String name;
  final String description;
  final Status status;
  final int createBy;
  final TimeStamp timeStamp;
  UpdateTaskEvent(this.id, this.stagedId, this.name, this.description, this.status, this.createBy, this.timeStamp);

  @override
  List<Object?> get props => [id, stagedId, name, description, status, createBy, timeStamp];
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  DeleteTaskEvent(this.id);

  @override
  List<Object?> get props => [id];
}