import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_state.dart';
import 'package:project_manager/feature/task/presentation/pages/v1/task_form.dart';
import 'package:project_manager/feature/task/presentation/pages/v2/task_formv2.dart'; // Import file form ta vừa tạo

class TaskPagev2 extends StatelessWidget {
  // final GetTaskUsecase getTaskUseCase;
  // final CreateTaskUsecase createTaskUseCase;
  // final UpdateTaskUsecase updateTaskUseCase;
  // final DeleteTaskUsecase deleteTaskUseCase;

  const TaskPagev2({
    super.key,
    // required this.getTaskUseCase,
    // required this.createTaskUseCase,
    // required this.updateTaskUseCase,
    // required this.deleteTaskUseCase,
  });

  @override
  Widget build(BuildContext context) {
    // Giả định TaskBloc đã được provided ở app root (giống file mẫu)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Task"), // Đổi tên
        centerTitle: true,
      ),
      body: BlocBuilder<TaskBloc, TaskState>( // Đổi sang TaskBloc/State
        builder: (context, state) {
          if (state is TaskLoadingState) { // Đổi state
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoadedState) { // Đổi state
            final tasks = state.tasks; // Đổi 'customers' -> 'tasks'
            if (tasks.isEmpty) {
              return const Center(child: Text("Chưa có Task nào")); // Đổi text
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final t = tasks[index]; // 't' for task
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      // Hiển thị chữ cái đầu của tên Task
                      child: Text(t.name.isNotEmpty ? t.name[0] : '?'),
                    ),
                    title: Text(
                      t.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column( // Cập nhật subtitle cho Task
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("Status: ${t.status.toString().split('.').last}"),
                        Text("Ngày hết hạn: ${t.timeStamp.endDate != null ? DateFormat('dd/MM/yyyy').format(t.timeStamp.endDate!) : '-'}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // --- THAY ĐỔI QUAN TRỌNG ---
                            // Mẫu dùng showDialog, ta dùng Navigator.push
                            // vì 'TaskFormPage' là 1 trang
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                // Truyền task vào để edit
                                builder: (_) => TaskFormPagev2(editingTask: t),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Gửi event Xóa
                            context.read<TaskBloc>().add(
                                  DeleteTaskEvent(t.id),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TaskErrorState) { // Đổi state
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const SizedBox(); // State ban đầu (Initial)
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- THAY ĐỔI QUAN TRỌNG ---
          // Mẫu dùng showDialog, ta dùng Navigator.push
          Navigator.of(context).push(
            MaterialPageRoute(
              // Không truyền task -> Form sẽ hiểu là "Thêm mới"
              builder: (_) => const TaskFormPagev2(), 
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}