import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_state.dart';
import 'package:project_manager/feature/stages/presentation/pages/stage_form.dart';
import 'package:project_manager/feature/stages/presentation/pages/stage_formv2.dart';
import 'package:project_manager/feature/task/presentation/pages/task_pagev2.dart';

class StagePagev2 extends StatelessWidget {
  // final GetStageUsecase getStageUsecase;
  // final CreateStageUsecase createStageUsecase;
  // final UpdateStageUsecase updateStageUsecase;
  // final DeletestageUsecase deleteStageUsecase;
  final int projectId;

  const StagePagev2({
    super.key,
    // required this.getStageUsecase,
    // required this.createStageUsecase,
    // required this.updateStageUsecase,
    // required this.deleteStageUsecase,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý giai đoạn"),
        centerTitle: true,
      ),
      body: BlocBuilder<StageBloc, StageState>(
        builder: (context, state) {
          if (state is StageLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StageLoadedState) {
            final stages = state.stage;  // ← Sửa từ stages thành stage
            if (stages.isEmpty) {
              return const Center(child: Text("Chưa có giai đoạn nào"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(stage.name.isNotEmpty ? stage.name[0] : '?'),
                    ),
                    title: Text(
                      stage.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (stage.description.isNotEmpty)
                              ? stage.description
                              : 'Không có mô tả nào',
                        ),
                        Text(
                          'Từ: ${stage.timestamps.startDate?.toLocal().toString().split(' ')[0] ?? 'N/A'} - '
                          'Đến: ${stage.timestamps.endDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Trạng thái: ${stage.status.toString().split('.').last}',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],

                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => StageFormDialog(
                                editingStage: stage,
                                projectId: projectId,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<StageBloc>().add(
                                  DeleteStageEvent(id: stage.id),  // ← Sửa thành named parameter
                                );
                          },
                        ),
                      ],
                    ),
                    onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPagev2(),
                        ),
                      );
                    }
                  ),
                );
              },
            );
          } else if (state is StageErrorState) {
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => StageFormDialogv2(projectId: projectId),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}