import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
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
    _descriptionController = TextEditingController(text: widget.editingStage?.description.data ?? '');
    _startDate = widget.editingStage?.timestamps.startDate;
    _endDate = widget.editingStage?.timestamps.endDate;
    _selectedStatus = widget.editingStage?.status ?? Status.pending;
  }

  // đảm bảo mỗi khi widget thay đổi (ví dụ sửa stage khác) thì dữ liệu cũng cập nhật
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
      // --- THÊM MỚI ---
      final newId = DateTime.now().millisecondsSinceEpoch;
      context.read<StageBloc>().add(
            CreateStageEvent(
              id: newId,
              name: name,
              projectId: widget.projectId,
              description: Text(description),
              startDate: _startDate!,
              endDate: _endDate!,
              status: _selectedStatus,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      // --- CẬP NHẬT ---
      context.read<StageBloc>().add(
            UpdateStageEvent(
              id: widget.editingStage!.id,
              name: name,
              projectId: widget.editingStage!.projectId,
              description: Text(description),
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
    return AlertDialog(
      title: Text(
        widget.editingStage == null ? "Thêm giai đoạn" : "Chỉnh sửa giai đoạn",
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Tên giai đoạn"),
                validator: (v) => v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Mô tả"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  _startDate == null
                      ? "Chọn ngày bắt đầu"
                      : "Ngày bắt đầu: ${_dateFormat.format(_startDate!)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text(
                  _endDate == null
                      ? "Chọn ngày kết thúc"
                      : "Ngày kết thúc: ${_dateFormat.format(_endDate!)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Status>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: "Trạng thái"),
                items: Status.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Hủy"),
        ),
        ElevatedButton(onPressed: _onSave, child: const Text("Lưu")),
      ],
    );
  }
}