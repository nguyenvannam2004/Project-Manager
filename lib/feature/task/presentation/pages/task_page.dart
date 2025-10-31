import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_state.dart';
import 'package:project_manager/feature/task/presentation/pages/task_form.dart';

class TaskPage extends StatelessWidget {
  // final GetTaskUsecase getTaskUseCase;
  // final CreateTaskUsecase createTaskUseCase;
  // final UpdateTaskUsecase updateTaskUseCase;
  // final DeleteTaskUsecase deleteTaskUseCase;
  final int stageId;

  const TaskPage({
    super.key,
    // required this.getTaskUseCase,
    // required this.createTaskUseCase,
    // required this.updateTaskUseCase,
    // required this.deleteTaskUseCase,
    required this.stageId,
  });

  @override
  Widget build(BuildContext context) {
    // --- Hàm Helper định nghĩa màu cho Status (Giống mẫu) ---
    Color statusColor(status) {
      // Dùng 'Status' enum của Task
      switch (status) {
        case Status.todo:
        case Status.pending: // THÊM
          return const Color(0xFFF59E0B); // Amber
        case Status.inProgress:
          return const Color(0xFF3B82F6); // Blue
        case Status.completed: // SỬA (từ done)
          return const Color(0xFF10B981); // Emerald
        case Status.cancelled: // THÊM
          return const Color(0xFFEF4444); // Red
        default:
          return const Color(0xFF6B7280); // Gray
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // --- App Bar (Giống mẫu) ---
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Quản lý Task", // Đổi tên
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
                      Color(0xFF6366F1), // Giữ nguyên dải màu tím
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
          // --- Content (Đổi Stage -> Task) ---
          SliverFillRemaining(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                // --- Trạng thái Loading (Giống mẫu) ---
                if (state is TaskLoadingState) {
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
                          'Đang tải dữ liệu Tasks...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                // --- Trạng thái Loaded (Đổi Stage -> Task) ---
                else if (state is TaskLoadedState) {
                  final tasks = state.tasks;
                  // Trạng thái Rỗng (Giống mẫu)
                  if (tasks.isEmpty) {
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
                                Icons.task_alt_rounded, // Đổi Icon
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Chưa có Task nào', // Đổi Text
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Tạo Task đầu tiên để bắt đầu\nquản lý công việc', // Đổi Text
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
                                    // Gọi TaskForm (từ file Canvas)
                                    builder: (_) => const TaskForm(),
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
                                  'Tạo Task', // Đổi Text
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
                  // Trạng thái có Dữ liệu
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: _ModernTaskCard(
                          // Dùng Card mới
                          task: task,
                          statusColor: statusColor,
                          onEdit: () {
                            HapticFeedback.lightImpact();
                            showDialog(
                              context: context,
                              builder: (_) => TaskForm(
                                editingTask: task, // Truyền task vào
                              ),
                            );
                          },
                          onDelete: () {
                            HapticFeedback.lightImpact();
                            // --- THÊM HỘP THOẠI XÁC NHẬN ---
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Xác nhận xóa"),
                                  content: Text(
                                    "Bạn có chắc chắn muốn xóa Task '${task.name}' không?",
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Hủy"),
                                      onPressed: () {
                                        Navigator.of(
                                          dialogContext,
                                        ).pop(); // Đóng dialog
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        "Xóa",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          dialogContext,
                                        ).pop(); // Đóng dialog
                                        // Gửi event xóa
                                        context.read<TaskBloc>().add(
                                          DeleteTaskEvent(task.id),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            // --- KẾT THÚC THÊM ---
                          },
                        ),
                      );
                    },
                  );
                }
                // --- Trạng thái Lỗi (Giống mẫu) ---
                else if (state is TaskErrorState) {
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
                          "Lỗi: ${state.message}",
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
                return const SizedBox(); // Trạng thái Initial
              },
            ),
          ),
        ],
      ),
      // --- FAB (Giống mẫu, chỉ đổi text và hàm 'onPressed') ---
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
              builder: (_) => const TaskForm(), // Gọi TaskForm
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: const Text(
            'Thêm Task', // Đổi Text
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.add_rounded, size: 22),
        ),
      ),
    );
  }
}

// --- CARD HIỂN THỊ TASK (Dựa theo _ModernStageCard) ---
class _ModernTaskCard extends StatelessWidget {
  final Task task; // Đổi 'stage' -> 'task'
  final Color Function(dynamic) statusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ModernTaskCard({
    required this.task,
    required this.statusColor,
    required this.onEdit,
    required this.onDelete,
  });

  // --- Helper functions (Copy từ mẫu, tùy chỉnh cho Task) ---
  IconData _getTaskIcon(status) {
    switch (status) {
      case Status.todo:
      case Status.pending: // THÊM
        return Icons.schedule_rounded;
      case Status.inProgress:
        return Icons.play_circle_rounded;
      case Status.completed: // SỬA (từ done)
        return Icons.check_circle_rounded;
      case Status.cancelled: // THÊM
        return Icons.cancel_rounded;
      default:
        return Icons.timeline_rounded;
    }
  }

  String _getStatusText(status) {
    switch (status) {
      case Status.todo:
        return 'Cần làm';
      case Status.pending: // THÊM
        return 'Chờ';
      case Status.inProgress:
        return 'Đang làm';
      case Status.completed: // SỬA (từ done)
        return 'Hoàn thành';
      case Status.cancelled: // THÊM
        return 'Hủy';
      default:
        return 'Không xác định';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yy').format(date); // Dùng DateFormat
  }

  @override
  Widget build(BuildContext context) {
    final color = statusColor(task.status);

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
          onTap: () => HapticFeedback.lightImpact(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Status indicator (Giống mẫu)
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
                    // Icon (Giống mẫu)
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
                        _getTaskIcon(task.status), // Dùng helper của Task
                        size: 24,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title và status (Giống mẫu)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.name, // Dùng task.name
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
                                  _getStatusText(
                                    task.status,
                                  ), // Dùng helper Task
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
                          // Mô tả (Đổi sang task.description)
                          (task.description.isNotEmpty)
                              ? Text(
                                  task.description,
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
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date và actions (Giống mẫu)
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
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            // Dùng timestamp của Task
                            '${_formatDate(task.timeStamp.startDate)} - ${_formatDate(task.timeStamp.endDate)}',
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
                    // Action buttons (Giống mẫu)
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

// --- WIDGET NÚT ACTION (Copy y hệt mẫu) ---
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
