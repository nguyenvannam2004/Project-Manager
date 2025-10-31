// lib/feature/task/presentation/pages/task_page.dart
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
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_state.dart';
import 'package:project_manager/feature/task/presentation/pages/v3/task_form.dart';


class TaskPage extends StatelessWidget {
  final int stageId;
  const TaskPage({super.key, required this.stageId});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(LoadTasksEvent());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          const GradientAppBar(title: "Quản lý Task", actions: []),
          SliverFillRemaining(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (_, state) {
                if (state is TaskLoadingState) return const AppLoading();
                if (state is TaskErrorState) return AppError(message: state.message);

                if (state is TaskLoadedState && state.tasks.isEmpty) {
                  return EmptyState(
                    title: "Chưa có Task nào",
                    subtitle: "Tạo Task đầu tiên để bắt đầu\nquản lý công việc",
                    icon: Icons.task_alt_rounded,
                    buttonText: "Tạo Task",
                    onPressed: () => _showForm(context),
                  );
                }

                if (state is TaskLoadedState) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    itemCount: state.tasks.length,
                    itemBuilder: (_, i) {
                      final task = state.tasks[i];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + i * 100),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: StatusCard(
                          item: task,
                          onTap: () => HapticFeedback.lightImpact(),
                          onEdit: () => _showForm(context, task),
                          onDelete: () => _confirmDelete(context, task),
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
        label: "Thêm Task",
        onPressed: () => _showForm(context),
      ),
    );
  }

  void _showForm(BuildContext context, [dynamic task]) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: TaskFormDialogv3(editingTask: task, stageId: stageId),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, dynamic task) async {
    final confirmed = await showDeleteDialog(context, itemName: task.name);
    if (confirmed == true) {
      HapticFeedback.mediumImpact();
      context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
    }
  }
}