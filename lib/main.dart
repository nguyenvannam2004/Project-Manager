import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/network/auth/ApiFromBackend.dart';
import 'package:project_manager/core/network/auth/IApiclient.dart';
import 'package:project_manager/feature/auth/presentation/pages/loginpagev2.dart';
import 'package:project_manager/feature/auth/presentation/pages/registerpage.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_bloc.dart';
import 'package:project_manager/feature/auth/data/datasource/AuthRemoteDataSource.dart';
import 'package:project_manager/feature/auth/data/repository_ipl/authrepository_ipl.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';
import 'package:project_manager/feature/auth/domain/usecase/LoginUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/LogoutUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/RegisterUsecase.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/pages/loginpage.dart';
import 'package:project_manager/feature/customer/data/repository_ipl/customerrepository_ipl.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/project/data/datasource/remotedatasource.dart';
//import 'package:project_manager/feature/project/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/project/data/repository_ipl/projectrepository_ipl.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';
import 'package:project_manager/feature/project/domain/repository/projectrepository.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/stages/data/datasource/remotedatasource.dart';
//import 'package:project_manager/feature/stages/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/stages/data/repository_ipl/stagesrepository_ipl.dart';
import 'package:project_manager/feature/stages/domain/repository/stage_repository.dart';
import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';
import 'package:project_manager/feature/task/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/task/data/repository_ipl/taskrepository_ipl.dart';
import 'package:project_manager/feature/task/domain/repository/taskrepository.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:project_manager/myapp.dart';

void main() {
  
  final IApiClient apiClient = ApiClientfrombackend('https://localhost:7277');
  final AuthRemoteDataSource authremoteDataSource = AuthRemoteDataSource(
    apiClient,
  );
  /// chức năng login
  final AuthRepository authRepository = AuthRepositoryImpl(
    authremoteDataSource,
  );
  final LoginUseCase loginUseCase = LoginUseCase(authRepository);
  final LogoutUseCase logoutUseCase = LogoutUseCase(authRepository);
  final RegisterUseCase registerUseCase = RegisterUseCase(authRepository);



  // chức năng liên quan tới tài nguyên khách hàng
  // final RemoteDataSource remotedatasrc = RemoteDataSource(apiClient);
  // final CustomerRepository customerRepository = CustomerRepositoryIpl(
  //   remotedatasrc,
  // );
  // final GetCustomerUsecase getcustomerUsecase = GetCustomerUsecase(
  //   customerRepository,
  // );
  // final DeleteCustomerUsecase deletecustomerUsecase = DeleteCustomerUsecase(
  //   customerRepository,
  // );
  // final CreatecustomerUsecase createCustomerUsecase = CreatecustomerUsecase(
  //   customerRepository,
  // );
  // final UpdateCustomerUsecase updateCustomerUsecase = UpdateCustomerUsecase(
  //   customerRepository,
  // );

  // chức năng liên quan tới tài nguyên project
  final RemoteDataSourceProject remotedatasrcproject = RemoteDataSourceProject(apiClient);
  final ProjectRepository projectRepository = ProjectRepositoryIpl(
    remotedatasrcproject,
  );
  final GetProjectUsecase getProjectUsecase = GetProjectUsecase(
    projectRepository,
  );
  final DeleteProjectUsecase deleteProjectUsecase = DeleteProjectUsecase(
    projectRepository,
  );
  final CreateProjectUsecase createProjectUsecase = CreateProjectUsecase(
    projectRepository,
  );
  final UpdateProjectUsecase updateProjectUsecase = UpdateProjectUsecase(
    projectRepository,
  );

// chức năng liên quan tới tài nguyên stages
    final RemoteDatasourceStage remotedatasrc = RemoteDatasourceStage(apiClient);
    final StageRepository stageRepository = StagesRepositoryIpl(
      remotedatasrc,
    );
    final GetStageUsecase getStageUsecase = GetStageUsecase(
      stageRepository,
    );
    final DeletestageUsecase deleteStageUsecase = DeletestageUsecase(
      stageRepository,
    );
    final CreateStageUsecase createStageUsecase = CreateStageUsecase(
      stageRepository,
    );
    final UpdateStageUsecase updateStageUsecase = UpdateStageUsecase(
      stageRepository,
    );

    // chức năng liên quan tới tài nguyên task
  final RemoteDataSourceTask remotedatasrctask = RemoteDataSourceTask(apiClient);
  final TaskRepository taskRepository = TaskRepositoryIpl(
    remotedatasrctask,
  );
  final GetTaskUsecase getTaskUsecase = GetTaskUsecase(
    taskRepository,
  );
  final CreateTaskUsecase createTaskUsecase = CreateTaskUsecase(
    taskRepository,
  );
  final UpdateTaskUsecase updateTaskUsecase = UpdateTaskUsecase(
    taskRepository,
  );
  final DeleteTaskUsecase deleteTaskUsecase = DeleteTaskUsecase(
    taskRepository,
  );
   
  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
      registerUseCase: registerUseCase, 
      
      
      getTaskUseCase: getTaskUsecase, 
      createTaskUseCase: createTaskUsecase, 
      updateTaskUseCase: updateTaskUsecase, 
      deleteTaskUseCase: deleteTaskUsecase, 

      getProjectUsecase: getProjectUsecase, 
      deleteProjectUsecase: deleteProjectUsecase, 
      createProjectUsecase: createProjectUsecase, 
      updateProjectUsecase: updateProjectUsecase, 
      
      getStageUsecase: getStageUsecase, 
      deleteStageUsecase: deleteStageUsecase, 
      createStageUsecase: createStageUsecase, 
      updateStageUsecase: updateStageUsecase,

      // getcustomerUsecase: null,
      // deletecustomerUsecase: null,
      // createCustomerUsecase: null, 
      // updateCustomerUsecase: null,
    ),
  );
}



