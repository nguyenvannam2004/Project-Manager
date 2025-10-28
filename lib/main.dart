import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/network/task/apiclient.dart';
import 'package:project_manager/feature/task/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/task/data/repository_ipl/taskrepository_ipl.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:project_manager/feature/task/presentation/pages/task_page.dart';

void main() {
  final Apiclient apiClient = Apiclient();
  final RemoteDataSource remoteDataSource = RemoteDataSource(apiClient);
  final TaskRepositoryIpl taskRepository = TaskRepositoryIpl(
    remoteDataSource,
  );
  final GetTaskUsecase gettaskUsecase = GetTaskUsecase(
    taskRepository,
  );
  final DeleteTaskUsecase deletetaskUsecase = DeleteTaskUsecase(
    taskRepository,
  );
  final CreateTaskUsecase createtaskUsecase = CreateTaskUsecase(
    taskRepository,
  );
  final UpdateTaskUsecase updatetaskUsecase = UpdateTaskUsecase(
    taskRepository,
  );
  runApp(
    MyApp(
      gettaskUsecase: gettaskUsecase,
      deletetaskUsecase: deletetaskUsecase,
      createtaskUsecase: createtaskUsecase,
      updatetaskUsecase: updatetaskUsecase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetTaskUsecase gettaskUsecase;
  final DeleteTaskUsecase deletetaskUsecase;
  final CreateTaskUsecase createtaskUsecase;
  final UpdateTaskUsecase updatetaskUsecase;
  const MyApp({
    super.key,
    required this.gettaskUsecase,
    required this.deletetaskUsecase,
    required this.createtaskUsecase,
    required this.updatetaskUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        
        BlocProvider(
          create: (context) => TaskBloc(
            getTaskUseCase: gettaskUsecase,
            createTaskUseCase: createtaskUsecase,
            updateTaskUseCase: updatetaskUsecase,
            deleteTaskUseCase: deletetaskUsecase,
          )..add(LoadTasksEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: TaskPage(
          getTaskUseCase: gettaskUsecase,
          deleteTaskUseCase: deletetaskUsecase,
          createTaskUseCase: createtaskUsecase,
          updateTaskUseCase: updatetaskUsecase,
        ),
      ),
    );
  }
}
