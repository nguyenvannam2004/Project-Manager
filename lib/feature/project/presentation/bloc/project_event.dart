import 'package:equatable/equatable.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';

abstract class ProjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProjectsEvent extends ProjectEvent {}

class CreateProjectEvent extends ProjectEvent {
  final int id;
  final String name;
  final String description;
  final Status status;
  final int createdBy;
  final TimeStamp timestamp;

  CreateProjectEvent(
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdBy,
    this.timestamp,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    status,
    createdBy,
    timestamp,
  ];
}

class UpdateProjectEvent extends ProjectEvent {
  final int id;
  final String name;
  final String description;
  final Status status;
  final int createdBy;
  final TimeStamp timestamp;

  UpdateProjectEvent(
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdBy,
    this.timestamp,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    status,
    createdBy,
    timestamp,
  ];
}

class DeleteProjectEvent extends ProjectEvent {
  final int id;

  DeleteProjectEvent(this.id);

  @override
  List<Object?> get props => [id];
}
