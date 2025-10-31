import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/entities/exception.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_state.dart';
import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_state.dart' hide StageForbiddenState;

class StageBloc extends Bloc<StageEvent, StageState> {
  final GetStageUsecase getStageUsecase;
  final DeletestageUsecase deleteStageUsecase;
  final CreateStageUsecase createStageUsecase;
  final UpdateStageUsecase updateStageUsecase;
  

  StageBloc({
    required this.getStageUsecase,
    required this.deleteStageUsecase,
    required this.createStageUsecase,
    required this.updateStageUsecase,
  }) : super(StageInitialState()) {
    on<LoadStageEvent>(_onLoadStages);
    on<CreateStageEvent>(_onCreateStage);
    on<UpdateStageEvent>(_onUpdateStage);
    on<DeleteStageEvent>(_onDeleteStage);
  }


  Future<void> _onLoadStages(
    LoadStageEvent event,
    Emitter<StageState> emit,
  ) async {
    emit(StageLoadingState());
    try {
      final stages = await getStageUsecase.call();
      emit(StageLoadedState(List.from(stages)));
    } catch (e) {
      emit(StageErrorState('Không thể tải danh sách giai đoạn: $e'));
    }
  }

  Future<void> _onCreateStage(
    CreateStageEvent event,
    Emitter<StageState> emit,
  ) async {
    emit(StageLoadingState());
    try {
      await createStageUsecase.call(
        event.id,
        event.name,
        event.projectId,
        event.description,
        event.startDate,
        event.endDate,
        event.status,
        event.createdAt,
        event.updatedAt,
      );

      final stages = await getStageUsecase.call();
      emit(StageLoadedState(List.from(stages)));
    } on ForbiddenException catch (e) {
      emit(StageForbiddenState(e.message) as StageState); // <- Bắt riêng Forbidden
    } catch (e) {
      emit(StageErrorState('Không thể tạo giai đoạn: $e'));
    }
  }

  Future<void> _onUpdateStage(
  UpdateStageEvent event,
  Emitter<StageState> emit,
) async {
  emit(StageLoadingState());
  try {
    await updateStageUsecase.call(
      event.id,
      event.name,
      event.projectId,
      event.description,
      event.startDate,
      event.endDate,
      event.status,
      event.createdAt,
      event.updatedAt,
    );

    final stages = await getStageUsecase.call();
    emit(StageLoadedState(List.from(stages)));
  } catch (e) {
    emit(StageErrorState('Không thể cập nhật giai đoạn: $e'));
  }
}


  // --- DELETE ---
  Future<void> _onDeleteStage(
    DeleteStageEvent event,
    Emitter<StageState> emit,
  ) async {
    emit(StageLoadingState());
    try {
      await deleteStageUsecase.call(event.id.toString());

      final stages = await getStageUsecase.call();
      emit(StageLoadedState(List.from(stages)));
    } catch (e) {
      emit(StageErrorState('Không thể xóa giai đoạn: $e'));
    }
  }
  
}


