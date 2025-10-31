import 'package:equatable/equatable.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';

abstract class ProjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectInitialState extends ProjectState {}

class ProjectLoadingState extends ProjectState {}

class ProjectLoadedState extends ProjectState {
  final List<Project> projects;

  ProjectLoadedState(this.projects);

  @override
  List<Object?> get props => [projects];
}
class ProjectForbiddenState extends ProjectState {
  final String message;
  ProjectForbiddenState(this.message);
}


class ProjectErrorState extends ProjectState {
  final String message;

  ProjectErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
