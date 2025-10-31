



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
//import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';

class StageFormDialog extends StatefulWidget {
  final Stage? editingStage;
  final int projectId;

  const StageFormDialog({
    super.key,
    this.editingStage,
    required this.projectId,
  });

  @override
  State<StageFormDialog> createState() => _StageFormDialogState();
}

class _StageFormDialogState extends State<StageFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _endDate;
  Status _selectedStatus = Status.pending;
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    _nameController = TextEditingController(text: widget.editingStage?.name ?? '');
    _descriptionController = TextEditingController(text: widget.editingStage?.description ?? '');
    _startDate = widget.editingStage?.timestamps.startDate;
    _endDate = widget.editingStage?.timestamps.endDate;
    _selectedStatus = widget.editingStage?.status ?? Status.pending;
  }

  @override
  void didUpdateWidget(covariant StageFormDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingStage != oldWidget.editingStage) {
      _initForm();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
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

  String _getStatusLabel(Status status) {
    switch (status) {
      case Status.pending:
        return 'Chờ thực hiện';
      case Status.inProgress:
        return 'Đang thực hiện';
      case Status.completed:
        return 'Hoàn thành';
      case Status.cancelled:
        return 'Đã hủy';
      default:
        return status.toString().split('.').last;
    }
  }

  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.pending:
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

  Future<void> _showDeleteConfirmation() async {
    final colorScheme = Theme.of(context).colorScheme;
    
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Xác nhận xóa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn có chắc chắn muốn xóa giai đoạn này?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Hành động này không thể hoàn tác',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Hủy'),
            ),
            // FilledButton.icon(
            //   onPressed: () => Navigator.of(context).pop(true),
            //   icon: const Icon(Icons.delete_rounded, size: 20),
            //   label: const Text('Xóa'),
            //   style: FilledButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );

    if (confirmed == true && widget.editingStage != null) {
      context.read<StageBloc>().add(
            DeleteStageEvent(id: widget.editingStage!.id),
          );
      if (mounted) {
        Navigator.of(context).pop();
      }
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
    final now = DateTime.now();

    if (widget.editingStage == null) {
      final newId = DateTime.now().millisecondsSinceEpoch;
      context.read<StageBloc>().add(
            CreateStageEvent(
              id: newId,
              name: name,
              projectId: widget.projectId,
              description: description,
              startDate: _startDate!,
              endDate: _endDate!,
              status: _selectedStatus,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      context.read<StageBloc>().add(
            UpdateStageEvent(
              id: widget.editingStage!.id,
              name: name,
              projectId: widget.editingStage!.projectId,
              description: description,
              startDate: _startDate!,
              endDate: _endDate!,
              status: _selectedStatus,
              createdAt: widget.editingStage!.timestamps.createdAt,
              updatedAt: now,
            ),
          );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.editingStage != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
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
                          isEditing ? "Chỉnh sửa giai đoạn" : "Thêm giai đoạn mới",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing ? "Cập nhật thông tin giai đoạn" : "Tạo giai đoạn cho dự án",
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
                      // Tên giai đoạn
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Tên giai đoạn",
                          hintText: "Nhập tên giai đoạn",
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Vui lòng nhập tên giai đoạn" : null,
                      ),
                      const SizedBox(height: 20),

                      // Mô tả
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: "Mô tả",
                          hintText: "Nhập mô tả chi tiết",
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
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),

                      // Ngày bắt đầu và kết thúc
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              onTap: () => _selectDate(context, true),
                              decoration: InputDecoration(
                                labelText: "Ngày bắt đầu",
                                hintText: "Chọn ngày",
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
                                suffixIcon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              controller: TextEditingController(
                                text: _startDate == null ? "" : _dateFormat.format(_startDate!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              onTap: () => _selectDate(context, false),
                              decoration: InputDecoration(
                                labelText: "Ngày kết thúc",
                                hintText: "Chọn ngày",
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
                                suffixIcon: Icon(
                                  Icons.calendar_today_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              controller: TextEditingController(
                                text: _endDate == null ? "" : _dateFormat.format(_endDate!),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Trạng thái
                      DropdownButtonFormField<Status>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: "Trạng thái",
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        items: Status.values.map((status) {
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

            // Actions
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút xóa (chỉ hiện khi đang chỉnh sửa)
                  if (isEditing)
                    TextButton.icon(
                      onPressed: _showDeleteConfirmation,
                      icon: const Icon(Icons.delete_rounded, size: 20),
                      label: const Text("Xóa"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  Row(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}