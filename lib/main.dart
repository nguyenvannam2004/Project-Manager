import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/network/project/apiclient.dart';
import 'package:project_manager/feature/project/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/project/data/repository_ipl/projectrepository_ipl.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/project/presentation/pages/project_page.dart';

void main() {
  final Apiclient apiClient = Apiclient();
  final RemoteDataSource remoteDataSource = RemoteDataSource(apiClient);
  final ProjectRepositoryIpl projectRepository = ProjectRepositoryIpl(
    remoteDataSource,
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
  runApp(
    MyApp(
      getProjectUsecase: getProjectUsecase,
      deleteProjectUsecase: deleteProjectUsecase,
      createProjectUsecase: createProjectUsecase,
      updateProjectUsecase: updateProjectUsecase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetProjectUsecase getProjectUsecase;
  final DeleteProjectUsecase deleteProjectUsecase;
  final CreateProjectUsecase createProjectUsecase;
  final UpdateProjectUsecase updateProjectUsecase;
  const MyApp({
    super.key,
    required this.getProjectUsecase,
    required this.deleteProjectUsecase,
    required this.createProjectUsecase,
    required this.updateProjectUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProjectBloc(
            getProjectUsecase: getProjectUsecase,
            createProjectUsecase: createProjectUsecase,
            updateProjectUsecase: updateProjectUsecase,
            deleteProjectUsecase: deleteProjectUsecase,
          )..add(LoadProjectsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Project Manager',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: ProjectPage(
          getProjectUsecase: getProjectUsecase,
          deleteProjectUsecase: deleteProjectUsecase,
          createProjectUsecase: createProjectUsecase,
          updateProjectUsecase: updateProjectUsecase,
        ),
      ),
    );
  }
}
