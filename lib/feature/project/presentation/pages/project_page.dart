import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_state.dart';
import 'package:project_manager/feature/project/presentation/pages/project_form.dart';

class ProjectPage extends StatelessWidget {
  final GetProjectUsecase getProjectUsecase;
  final CreateProjectUsecase createProjectUsecase;
  final UpdateProjectUsecase updateProjectUsecase;
  final DeleteProjectUsecase deleteProjectUsecase;

  const ProjectPage({
    super.key,
    required this.getProjectUsecase,
    required this.createProjectUsecase,
    required this.updateProjectUsecase,
    required this.deleteProjectUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý dự án"), centerTitle: true),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectLoadedState) {
            final projects = state.projects;
            if (projects.isEmpty) {
              return const Center(child: Text("Chưa có dự án nào"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      project.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                project.status.toString().split('.').last,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _getStatusColor(project.status),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Bắt đầu: ${_formatDate(project.timestamp.startDate)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Kết thúc: ${_formatDate(project.timestamp.endDate)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
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
                              builder: (_) =>
                                  ProjectFormDialog(editingProject: project),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Thêm dialog xác nhận xóa
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: const Text(
                                    'Bạn có chắc chắn muốn xóa dự án này?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<ProjectBloc>().add(
                                          DeleteProjectEvent(project.id),
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Xóa'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProjectErrorState) {
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const ProjectFormDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    switch (status.toString().split('.').last.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'inprogress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
