

import 'package:flutter/material.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';

// Tên class là TaskForm (không có Dialog)
class TaskForm extends StatefulWidget {
  final Task? editingTask;

  const TaskForm({
    super.key,
    this.editingTask,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  // Thêm Controller cho các trường của Task
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _stageIdController;
  late TextEditingController _createByController;

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _createdAt; // Dùng để lưu ngày tạo gốc khi update
  Status _selectedStatus = Status.todo; // Mặc định cho Task
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    final task = widget.editingTask;
    _nameController = TextEditingController(text: task?.name ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
    // Thêm 2 trường mới
    _stageIdController =
        TextEditingController(text: task?.stagedId.toString() ?? '');
    _createByController =
        TextEditingController(text: task?.createBy.toString() ?? '');
    
    // Giả định timestamp không null
    _startDate = task?.timeStamp.startDate;
    _endDate = task?.timeStamp.endDate;
    _createdAt = task?.timeStamp.createdAt; // Lưu lại ngày tạo
    _selectedStatus = task?.status ?? Status.todo;
  }

  @override
  void didUpdateWidget(covariant TaskForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingTask != oldWidget.editingTask) {
      _initForm(); // Tải lại form nếu task truyền vào thay đổi
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stageIdController.dispose();
    _createByController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // --- Các hàm helper cho Status (Giống hệt file mẫu) ---

  String _getStatusLabel(Status status) {
    switch (status) {
      case Status.todo:
        return 'Cần làm';
      case Status.inProgress:
        return 'Đang làm';
      case Status.completed:
        return 'Hoàn thành';
      case Status.cancelled:
        return 'Đã hủy';
      default:
        return status.toString().split('.').last; 
    }
  }

  // Tùy chỉnh màu cho Status
  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.todo:
        return Colors.orange;
      case Status.inProgress:
        return Colors.blue;
      case Status.completed:
        return Colors.green;
      case Status.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày bắt đầu và kết thúc')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final stageId = int.tryParse(_stageIdController.text.trim());
    final createBy = int.tryParse(_createByController.text.trim());

    if (stageId == null || createBy == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stage ID và Người tạo ID phải là số')),
      );
      return;
    }

    final now = DateTime.now();

    if (widget.editingTask == null) {
      // --- THÊM MỚI TASK ---
      final newId = DateTime.now().millisecondsSinceEpoch;
      final timeStamp = TimeStamp(
        now, // createdAt
        now, // updatedAt
        _startDate!,
        _endDate!,
      );
      context.read<TaskBloc>().add(
            CreateTaskEvent(
              newId,
              stageId,
              name,
              description,
              _selectedStatus,
              createBy,
              timeStamp,
            ),
          );
    } else {
      // --- CẬP NHẬT TASK ---
      final timeStamp = TimeStamp(
        _createdAt!, // Giữ ngày tạo gốc
        now, // Cập nhật ngày mới
        _startDate!,
        _endDate!,
      );
      context.read<TaskBloc>().add(
            UpdateTaskEvent(
              widget.editingTask!.id,
              stageId,
              name,
              description,
              _selectedStatus,
              createBy,
              timeStamp,
            ),
          );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.editingTask != null;

    // --- Cấu trúc UI y hệt file mẫu ---
    // Vì đây là file form, ta trả về Dialog
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500), // Giới hạn chiều rộng
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isEditing ? Icons.edit_rounded : Icons.add_rounded,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? "Chỉnh sửa Task" : "Thêm Task mới",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing
                              ? "Cập nhật thông tin Task"
                              : "Tạo một Task mới",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tên Task
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(
                          context,
                          labelText: "Tên Task",
                          hintText: "Nhập tên Task",
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Vui lòng nhập tên" : null,
                      ),
                      const SizedBox(height: 20),

                      // Mô tả
                      TextFormField(
                        controller: _descriptionController,
                        decoration: _buildInputDecoration(
                          context,
                          labelText: "Mô tả",
                          hintText: "Nhập mô tả chi tiết",
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),

                      // Thêm 2 trường mới cho Task
                      Row(
                         children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stageIdController,
                                decoration: _buildInputDecoration(
                                  context,
                                  labelText: "Stage ID",
                                  hintText: "Nhập ID",
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Nhập ID" : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                             Expanded(
                              child: TextFormField(
                                controller: _createByController,
                                decoration: _buildInputDecoration(
                                  context,
                                  labelText: "Người tạo (ID)",
                                  hintText: "Nhập ID",
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Nhập ID" : null,
                              ),
                            ),
                         ],
                      ),
                      const SizedBox(height: 20),

                      // Ngày bắt đầu và kết thúc (Copy y hệt)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              onTap: () => _selectDate(context, true),
                              decoration: _buildInputDecoration(
                                context,
                                labelText: "Ngày bắt đầu",
                                hintText: "Chọn ngày",
                                suffixIcon: Icons.calendar_today_rounded,
                              ),
                              controller: TextEditingController(
                                text: _startDate == null
                                    ? ""
                                    : _dateFormat.format(_startDate!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              onTap: () => _selectDate(context, false),
                              decoration: _buildInputDecoration(
                                context,
                                labelText: "Ngày kết thúc",
                                hintText: "Chọn ngày",
                                suffixIcon: Icons.calendar_today_rounded,
                              ),
                              controller: TextEditingController(
                                text: _endDate == null
                                    ? ""
                                    : _dateFormat.format(_endDate!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Trạng thái (Copy y hệt, chỉ đổi 'Status.values')
                      DropdownButtonFormField<Status>(
                        value: _selectedStatus,
                        decoration: _buildInputDecoration(
                          context,
                          labelText: "Trạng thái",
                          hintText: "Chọn trạng thái",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: Status.values.map((status) { // Dùng Status của Task
                          return DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(_getStatusLabel(status)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
          }
        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Actions (Copy y hệt)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Hủy"),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _onSave,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(isEditing ? "Cập nhật" : "Tạo mới"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm helper tạo style cho TextFormField (giống mẫu)
  InputDecoration _buildInputDecoration(
    BuildContext context, {
    required String labelText,
    required String hintText,
    IconData? suffixIcon,
    bool alignLabelWithHint = false,
    EdgeInsetsGeometry? contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      filled: true,
      fillColor: colorScheme.surface,
      alignLabelWithHint: alignLabelWithHint,
      contentPadding: contentPadding,
      suffixIcon: suffixIcon != null
          ? Icon(
              suffixIcon,
              color: colorScheme.primary,
              size: 20,
            )
          : null,
    );
  }
}

