import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent,TaskState > {
  final GetTaskUsecase getTaskUseCase;
  final CreateTaskUsecase createTaskUseCase;
  final UpdateTaskUsecase updateTaskUseCase;
  final DeleteTaskUsecase deleteTaskUseCase;

  TaskBloc({
    required this.getTaskUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitialState()) {
    
    on<LoadTasksEvent>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }
    
  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoadingState());
    try {
      final tasks = await getTaskUseCase.call();
      emit(TaskLoadedState(List.from(tasks)));
    } catch (e) {
      emit(TaskErrorState('Không thể tải danh sách: $e'));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoadingState());
    try {
      await createTaskUseCase.call(
        event.id,
        event.stagedId,
        event.name,
        event.description,
        event.status,
        event.createBy,
        event.timeStamp.createdAt,
        event.timeStamp.updatedAt ?? DateTime.now(),
        event.timeStamp.startDate ?? DateTime.now(),
        event.timeStamp.endDate ?? DateTime.now(),
        
      );
      final tasks = await getTaskUseCase.call();
      emit(TaskLoadedState(List.from(tasks)));
    } catch (e, stackTrace) {
      emit(TaskErrorState('Không thể tạo: $e'));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoadingState());
    try {
      await updateTaskUseCase.call(
        event.id,
        event.stagedId,
        event.name,
        event.description,
        event.status,
        event.createBy,
        event.timeStamp.createdAt,
        event.timeStamp.updatedAt ?? DateTime.now(), 
        event.timeStamp.startDate ?? DateTime.now(),
        event.timeStamp.endDate ?? DateTime.now(),
      );
      final tasks = await getTaskUseCase.call();
      emit(TaskLoadedState(List.from(tasks))); // Tạo bản sao
    } catch (e, stackTrace) {
      emit(TaskErrorState('Không thể cập nhật khách hàng: $e'));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoadingState());
    try {
      await deleteTaskUseCase.call(event.id);
      final tasks = await getTaskUseCase.call();
      emit(TaskLoadedState(List.from(tasks))); 
    } catch (e, stackTrace) {
      emit(TaskErrorState('Không thể xóa khách hàng: $e'));
    }
  }

}