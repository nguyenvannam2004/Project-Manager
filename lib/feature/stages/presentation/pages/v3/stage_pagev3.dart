// lib/feature/stages/presentation/pages/stage_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/widget/delete_confirm_dialog.dart';
import 'package:project_manager/core/widget/empty_state.dart';
import 'package:project_manager/core/widget/error_view.dart';
import 'package:project_manager/core/widget/gradient_appbar.dart';
import 'package:project_manager/core/widget/gradient_fab.dart';
import 'package:project_manager/core/widget/loading_view.dart';
import 'package:project_manager/core/widget/status_card.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_state.dart';
import 'package:project_manager/feature/stages/presentation/pages/v1/stage_form.dart';
import 'package:project_manager/feature/task/presentation/pages/v1/task_page.dart';

class StagePagev3 extends StatelessWidget {
  final int projectId;
  const StagePagev3({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    context.read<StageBloc>().add(LoadStageEvent()); 

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          const GradientAppBar(title: "Giai đoạn dự án", actions: [],),
          SliverFillRemaining(
            child: BlocBuilder<StageBloc, StageState>(
              builder: (_, state) {
                if (state is StageLoadingState) return const AppLoading();
                if (state is StageErrorState) return AppError(message: state.message);

                if (state is StageLoadedState && state.stage.isEmpty) {
                  return EmptyState(
                    title: "Chưa có giai đoạn nào",
                    subtitle: "Tạo giai đoạn đầu tiên để bắt đầu\nquản lý dự án một cách chuyên nghiệp",
                    icon: Icons.timeline_outlined,
                    buttonText: "Tạo giai đoạn",
                    onPressed: () => _showForm(context),
                  );
                }

                if (state is StageLoadedState) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    itemCount: state.stage.length,
                    itemBuilder: (_, i) {
                      final s = state.stage[i];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + i * 100),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: StatusCard(
                          item: s,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(context, MaterialPageRoute(builder: (_) => TaskPage(stageId: s.id)));
                          },
                          onEdit: () => _showForm(context, s),
                          onDelete: () => _confirmDelete(context, s),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFAB(
        label: "Thêm giai đoạn",
        onPressed: () => _showForm(context),
      ),
    );
  }

  void _showForm(BuildContext context, [dynamic stage]) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StageBloc>(),
        child: StageFormDialog(editingStage: stage, projectId: projectId),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, dynamic stage) async {
    final confirmed = await showDeleteDialog(context, itemName: stage.name);
    if (confirmed == true) {
      HapticFeedback.mediumImpact();
      context.read<StageBloc>().add(DeleteStageEvent(id: stage.id));
    }
  }
}