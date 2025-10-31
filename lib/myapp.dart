import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/domain/usecase/LoginUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/LogoutUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/RegisterUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/getuserusecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/updateroleUsecase.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/user/userbloc.dart';
import 'package:project_manager/feature/auth/presentation/pages/loginpage.dart';
import 'package:project_manager/feature/auth/presentation/pages/loginpagev2.dart';
import 'package:project_manager/feature/auth/presentation/pages/registerpage.dart';
import 'package:project_manager/feature/auth/presentation/pages/registerpagev2.dart';
import 'package:project_manager/feature/auth/presentation/pages/user_ui/user_page.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';

class MyApp extends StatelessWidget {
  // user
  final GetUserUsecase getUserUsecase;
  final UpdateRoleUseCase updateRoleUseCase;


// task
  final GetTaskUsecase getTaskUseCase;
  final CreateTaskUsecase createTaskUseCase;
  final UpdateTaskUsecase updateTaskUseCase;
  final DeleteTaskUsecase deleteTaskUseCase;


//stages
  final GetStageUsecase getStageUsecase;
  final DeletestageUsecase deleteStageUsecase;
  final CreateStageUsecase createStageUsecase;
  final UpdateStageUsecase updateStageUsecase;

  // project
  final GetProjectUsecase getProjectUsecase;
  final DeleteProjectUsecase deleteProjectUsecase;
  final CreateProjectUsecase createProjectUsecase;
  final UpdateProjectUsecase updateProjectUsecase;

  // final GetCustomerUsecase getcustomerUsecase;
  // final DeleteCustomerUsecase deletecustomerUsecase;
  // final CreatecustomerUsecase createCustomerUsecase;
  // final UpdateCustomerUsecase updateCustomerUsecase;

  // auth
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,

    required this.getTaskUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,

    required this.getProjectUsecase,
    required this.deleteProjectUsecase,
    required this.createProjectUsecase,
    required this.updateProjectUsecase,

    required this.getStageUsecase,
    required this.deleteStageUsecase,
    required this.createStageUsecase,
    required this.updateStageUsecase, 
    
    required this.getUserUsecase, 
    required this.updateRoleUseCase,

    // required this.getcustomerUsecase,
    // required this.deletecustomerUsecase,
    // required this.createCustomerUsecase,
    // required this.updateCustomerUsecase,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: loginUseCase,
            logoutUseCase: logoutUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => TaskBloc(
            getTaskUseCase: getTaskUseCase,
            createTaskUseCase: createTaskUseCase,
            updateTaskUseCase: updateTaskUseCase,
            deleteTaskUseCase: deleteTaskUseCase,
          )..add(LoadTasksEvent()),
        ),

        BlocProvider(
          create: (context) => ProjectBloc(
            getProjectUsecase: getProjectUsecase,
            deleteProjectUsecase: deleteProjectUsecase,
            createProjectUsecase: createProjectUsecase,
            updateProjectUsecase: updateProjectUsecase,
          )..add(LoadProjectsEvent()),
        ),
        BlocProvider(
          create: (context) => UserBloc(getUserUsecase,updateRoleUseCase),
          child: UserPage(),
        ),
        BlocProvider(
          create: (context) => StageBloc(
            getStageUsecase: getStageUsecase,
            deleteStageUsecase: deleteStageUsecase,
            createStageUsecase: createStageUsecase,
            updateStageUsecase: updateStageUsecase,
          )..add(LoadStageEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LoginPage(
          // getTaskUseCase: getTaskUseCase,
          // createTaskUseCase: createTaskUseCase,
          // updateTaskUseCase: updateTaskUseCase,
          // deleteTaskUseCase: deleteTaskUseCase,

          // getStageUsecase: getStageUsecase,
          // deleteStageUsecase: deleteStageUsecase,
          // createStageUsecase: createStageUsecase,
          // updateStageUsecase: updateStageUsecase,

          // updateProjectUsecase: updateProjectUsecase,
          // getProjectUsecase: getProjectUsecase,
          // deleteProjectUsecase: deleteProjectUsecase,
          // createProjectUsecase: createProjectUsecase,

          // getcustomerUsecase: getcustomerUsecase,
          // deletecustomerUsecase: deletecustomerUsecase,
          // createCustomerUsecase: createCustomerUsecase,
          // updateCustomerUsecase: updateCustomerUsecase,
        ),

        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/users': (context) => UserPage(),
        },
      ),
    );
  }
}
