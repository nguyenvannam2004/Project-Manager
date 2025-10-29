import 'package:equatable/equatable.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';

abstract class StageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StageInitialState extends StageState {}
class StageLoadingState extends StageState {}
class StageLoadedState extends StageState {
  final List <Stage> stage;

  StageLoadedState(this.stage);

  @override
  List<Object?> get props => [stage];
}

class StageErrorState extends StageState {
  final String message;

  StageErrorState(this.message);

  @override
  List<Object?> get props => [message];
}