import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authevent.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_state.dart';
import 'package:project_manager/feature/project/presentation/pages/v1/project_form.dart';
import 'package:project_manager/feature/stages/presentation/pages/v1/stage_page.dart';

class ProjectPage extends StatelessWidget {
  // final GetProjectUsecase getProjectUsecase;
  // final CreateProjectUsecase createProjectUsecase;
  // final UpdateProjectUsecase updateProjectUsecase;
  // final DeleteProjectUsecase deleteProjectUsecase;

  const ProjectPage({
    super.key,
    // required this.getProjectUsecase,
    // required this.createProjectUsecase,
    // required this.updateProjectUsecase,
    // required this.deleteProjectUsecase,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ProjectBloc>().add(LoadProjectsEvent());
    // Hàm statusColor từ stage_page.dart
    Color statusColor(Status status) {
      switch (status) {
        case Status.pending:
          return const Color(0xFFF59E0B); // Amber
        case Status.inProgress:
          return const Color(0xFF3B82F6); // Blue
        case Status.completed:
          return const Color(0xFF10B981); // Emerald
        case Status.cancelled:
          return const Color(0xFFEF4444); // Red
        default:
          return const Color(0xFF6B7280); // Gray
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [ // ← THÊM VÀO ĐÂY
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                tooltip: 'Đăng xuất',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Quản lý Dự án", // Đã đổi tên
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFFA855F7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SliverFillRemaining(
            child: BlocListener<ProjectBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectForbiddenState) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Không có quyền'),
                    content: Text(state.message),
                    actions: [
                      TextButton(
                        onPressed: () 
                        {
                          Navigator.of(context).pop(); // Đóng dialog
                          context.read<ProjectBloc>().add(LoadProjectsEvent());
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoadingState) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF6366F1),
                          ),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Đang tải dữ liệu...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is ProjectLoadedState) {
                  final projects = state.projects; // Logic từ project_page.dart
                  if (projects.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.folder_copy_outlined, // Đổi icon
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Chưa có dự án nào', // Đổi text
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Tạo dự án đầu tiên để bắt đầu\nquản lý công việc một cách chuyên nghiệp', // Đổi text
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  showDialog(
                                    context: context,
                                    // Logic gọi dialog từ project_page.dart
                                    builder: (_) => const ProjectFormDialog(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                icon: const Icon(Icons.add_rounded, size: 22),
                                label: const Text(
                                  'Tạo dự án', // Đổi text
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project =
                          projects[index]; // Logic project_page.dart
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: _ModernProjectCard(
                          // Sử dụng Card tùy chỉnh mới
                          project: project,
                          statusColor: statusColor(project.status),
                          // Truyền các helper functions từ project_page.dart
                          getProjectIcon: _getStatusIcon,
                          getStatusText: _getStatusText,
                          formatDateRange: _formatDateRange,
                          onEdit: () {
                            HapticFeedback.lightImpact();
                            showDialog(
                              context: context,
                              // Logic gọi dialog sửa từ project_page.dart
                              builder: (_) =>
                                  ProjectFormDialog(editingProject: project),
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StagePage(projectId: project.id),
                              ),
                            );
                          },
                          onDelete: () {
                            HapticFeedback.lightImpact();
                            // Logic gọi dialog xóa từ project_page.dart
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
                      );
                    },
                  );
                } else if (state is ProjectErrorState) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            size: 40,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Lỗi: ${state.message}", // Logic từ project_page.dart
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          ),
        ],

      ),
      // Giao diện FloatingActionButton từ stage_page.dart
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticFeedback.lightImpact();
            showDialog(
              context: context,
              // Logic gọi dialog từ project_page.dart
              builder: (_) => const ProjectFormDialog(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: const Text(
            'Thêm dự án', // Đổi text
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.add_rounded, size: 22),
        ),
      ),
    );
  }

  // --- BỘ HÀM HELPER TỪ PROJECT_PAGE.DART (GIỮ NGUYÊN) ---

  IconData _getStatusIcon(Status status) {
    switch (status) {
      case Status.inProgress:
        return Icons.check_circle;
      case Status.pending:
        return Icons.watch_later_outlined;
      case Status.completed:
        return Icons.check_circle;
      case Status.cancelled:
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusIconColor(Status status) {
    switch (status) {
      case Status.inProgress:
        return Colors.blue;
      case Status.pending:
        return Colors.orange;
      case Status.completed:
        return Colors.green;
      case Status.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(Status status) {
    switch (status) {
      case Status.inProgress:
        return 'Đang làm';
      case Status.pending:
        return 'Chờ';
      case Status.completed:
        return 'Hoàn thành';
      case Status.cancelled:
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  Color _getStatusChipColor(Status status) {
    switch (status) {
      case Status.inProgress:
        return Colors.blue[100]!;
      case Status.pending:
        return Colors.orange[100]!;
      case Status.completed:
        return Colors.green[100]!;
      case Status.cancelled:
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getStatusTextColor(Status status) {
    switch (status) {
      case Status.inProgress:
        return Colors.blue[800]!;
      case Status.pending:
        return Colors.orange[800]!;
      case Status.completed:
        return Colors.green[800]!;
      case Status.cancelled:
        return Colors.red[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }
}

// --- CARD WIDGET MỚI (DỰA TRÊN _ModernStageCard) ---

class _ModernProjectCard extends StatelessWidget {
  final dynamic project;
  final Color statusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  // Truyền các helper functions vào
  final IconData Function(Status) getProjectIcon;
  final String Function(Status) getStatusText;
  final String Function(DateTime?, DateTime?) formatDateRange;

  const _ModernProjectCard({
    required this.project,
    required this.statusColor,
    required this.onEdit,
    required this.onDelete,
    required this.getProjectIcon,
    required this.getStatusText,
    required this.formatDateRange, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = statusColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            if (onTap != null) {
            onTap!(); // gọi callback từ ProjectPage
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Status indicator
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Project icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withOpacity(0.1),
                            color.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        getProjectIcon(project.status), // Dùng helper
                        size: 24,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title and status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project.name, // Logic project_page.dart
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2937),
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [color, color.withOpacity(0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  getStatusText(project.status), // Dùng helper
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Logic description (đã sửa lỗi từ các tin nhắn trước)
                          (project.description.isNotEmpty)
                              ? Text(
                                  project.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7280),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text(
                                  'Không có mô tả',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date and actions row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            // Dùng helper và logic đã sửa
                            formatDateRange(
                              project.timestamp.startDate,
                              project.timestamp.endDate,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Modern action buttons
                    Row(
                      children: [
                        _ModernActionButton(
                          icon: Icons.edit_rounded,
                          color: const Color(0xFF3B82F6),
                          onTap: onEdit,
                        ),
                        const SizedBox(width: 8),
                        _ModernActionButton(
                          icon: Icons.delete_rounded,
                          color: const Color(0xFFEF4444),
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET NÚT (GIỮ NGUYÊN TỪ STAGE_PAGE.DART) ---
class _ModernActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModernActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

