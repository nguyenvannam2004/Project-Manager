// lib/feature/project/presentation/pages/project_page.dart
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
import 'package:project_manager/feature/auth/presentation/bloc/auth/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authevent.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_state.dart';
import 'package:project_manager/feature/project/presentation/pages/v1/project_form.dart';
import 'package:project_manager/feature/stages/presentation/pages/v1/stage_page.dart';

class ProjectPagev3 extends StatelessWidget {
  const ProjectPagev3({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProjectBloc>().add(LoadProjectsEvent());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          GradientAppBar(
            title: "Quản lý Dự án",
            actions: [
              IconButton(
                  icon: const Icon(Icons.account_circle_rounded, size: 28),
                  tooltip: 'Người dùng',
                  onPressed: () {
                    Navigator.pushNamed(context, '/users');
                  },
                ),
                const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                tooltip: 'Đăng xuất',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverFillRemaining(
            child: BlocListener<ProjectBloc, ProjectState>(
              listener: (ctx, state) {
                if (state is ProjectForbiddenState) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (_, state) {
                  if (state is ProjectLoadingState) return const AppLoading();
                  if (state is ProjectErrorState) return AppError(message: state.message);

                  if (state is ProjectLoadedState && state.projects.isEmpty) {
                    return EmptyState(
                      title: "Chưa có dự án nào",
                      subtitle: "Tạo dự án đầu tiên để bắt đầu\nquản lý công việc một cách chuyên nghiệp",
                      icon: Icons.folder_copy_outlined,
                      buttonText: "Tạo dự án",
                      onPressed: () => _showForm(context),
                    );
                  }

                  if (state is ProjectLoadedState) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: state.projects.length,
                      itemBuilder: (_, i) {
                        final p = state.projects[i];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + i * 100),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: StatusCard(
                            item: p,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StagePage(projectId: p.id))),
                            onEdit: () => _showForm(context, p),
                            onDelete: () => _confirmDelete(context, p),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFAB(
        label: "Thêm dự án",
        onPressed: () => _showForm(context),
      ),
    );
  }

  void _showForm(BuildContext context, [dynamic project]) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ProjectBloc>(),
        child: ProjectFormDialog(editingProject: project),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, dynamic project) async {
    final confirmed = await showDeleteDialog(context, itemName: project.name);
    if (confirmed == true) {
      HapticFeedback.mediumImpact();
      context.read<ProjectBloc>().add(DeleteProjectEvent(project.id));
    }
  }
}