import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/network/stages/apiclient.dart'; // ← Import ApiClient từ stages
import 'package:project_manager/feature/stages/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/stages/data/repository_ipl/stagesrepository_ipl.dart';
import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';
import 'package:project_manager/feature/stages/presentation/pages/stage_page.dart';

void main() {
  // Stage setup - Dùng ApiClient từ stages
  final ApiClient apiClient = ApiClient(); // ← ApiClient từ stages
  final RemoteDatasource stageRemoteDataSource = RemoteDatasource(apiClient);
  final StagesRepositoryIpl stageRepository = StagesRepositoryIpl(
    stageRemoteDataSource,
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

  runApp(
    MyApp(
      getStageUsecase: getStageUsecase,
      deleteStageUsecase: deleteStageUsecase,
      createStageUsecase: createStageUsecase,
      updateStageUsecase: updateStageUsecase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetStageUsecase getStageUsecase;
  final DeletestageUsecase deleteStageUsecase;
  final CreateStageUsecase createStageUsecase;
  final UpdateStageUsecase updateStageUsecase;

  const MyApp({
    super.key,
    required this.getStageUsecase,
    required this.deleteStageUsecase,
    required this.createStageUsecase,
    required this.updateStageUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StageBloc(
        getStageUsecase: getStageUsecase,
        createStageUsecase: createStageUsecase,
        updateStageUsecase: updateStageUsecase,
        deleteStageUsecase: deleteStageUsecase,
      )..add(LoadStageEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stage Manager',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: StagePage(
          getStageUsecase: getStageUsecase,
          deleteStageUsecase: deleteStageUsecase,
          createStageUsecase: createStageUsecase,
          updateStageUsecase: updateStageUsecase,
          projectId: 1,
        ),
      ),
    );
  }
}