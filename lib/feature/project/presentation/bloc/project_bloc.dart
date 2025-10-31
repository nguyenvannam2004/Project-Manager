import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/entities/exception.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetProjectUsecase getProjectUsecase;
  final CreateProjectUsecase createProjectUsecase;
  final DeleteProjectUsecase deleteProjectUsecase;
  final UpdateProjectUsecase updateProjectUsecase;

  ProjectBloc({
    required this.getProjectUsecase,
    required this.createProjectUsecase,
    required this.deleteProjectUsecase,
    required this.updateProjectUsecase,
  }) : super(ProjectInitialState()) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<CreateProjectEvent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
  }

  Future<void> _onLoadProjects(
    LoadProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoadingState());
    try {
      final projects = await getProjectUsecase.call();
      emit(ProjectLoadedState(List.from(projects)));
    } catch (e) {
      emit(ProjectErrorState('Không thể tải danh sách dự án: $e'));
    }
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoadingState());
    try {
      await createProjectUsecase.call(
        event.id,
        event.name,
        event.description,
        event.status,
        event.createdBy,
        event.timestamp.createdAt ?? DateTime.now(),
        event.timestamp.updatedAt ?? DateTime.now(),
        event.timestamp.startDate ?? DateTime.now(),
        event.timestamp.endDate ?? DateTime.now(),
      );
      final projects = await getProjectUsecase.call();
      emit(ProjectLoadedState(List.from(projects)));
    } on ForbiddenException catch (e) {
      emit(ProjectForbiddenState(e.message)); // <- Bắt riêng Forbidden
    } catch (e) {
      emit(ProjectErrorState('Không thể tạo dự án: $e'));
    }
  }

  Future<void> _onUpdateProject(
    UpdateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoadingState());
    try {
      await updateProjectUsecase.call(
        event.id,
        event.name,
        event.description,
        event.status,
        event.createdBy,
        event.timestamp.createdAt ?? DateTime.now(),
        event.timestamp.updatedAt ?? DateTime.now(),
        event.timestamp.startDate ?? DateTime.now(),
        event.timestamp.endDate ?? DateTime.now(),
      );
      final projects = await getProjectUsecase.call();
      emit(ProjectLoadedState(List.from(projects)));
    } on ForbiddenException catch (e) {
      emit(ProjectForbiddenState(e.message)); // <- Bắt riêng Forbidden
    } catch (e) {
      emit(ProjectErrorState('Không thể cập nhật dự án: $e'));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoadingState());
    try {
      await deleteProjectUsecase.call(event.id);
      final projects = await getProjectUsecase.call();
      emit(ProjectLoadedState(List.from(projects)));
    } on ForbiddenException catch (e) {
      emit(ProjectForbiddenState(e.message)); // <- Bắt riêng Forbidden
    } catch (e) {
      emit(ProjectErrorState('Không thể xóa dự án: $e'));
    }
  }
}
