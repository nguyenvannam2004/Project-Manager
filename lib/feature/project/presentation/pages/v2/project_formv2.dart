import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';

class ProjectFormDialogv2 extends StatefulWidget {
  final Project? editingProject;

  const ProjectFormDialogv2({super.key, this.editingProject});

  @override
  State<ProjectFormDialogv2> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialogv2> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  Status _selectedStatus = Status.pending;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.editingProject?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.editingProject?.description ?? '',
    );
    if (widget.editingProject != null) {
      _selectedStatus = widget.editingProject!.status;
      _startDate = widget.editingProject!.timestamp.startDate ?? DateTime.now();
      _endDate =
          widget.editingProject!.timestamp.endDate ??
          DateTime.now().add(const Duration(days: 7));
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
      initialDate: isStartDate ? _startDate : _endDate,
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
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      if (name.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
        );
        return;
      }

      final timestamp = TimeStamp(
        DateTime.now(),
        DateTime.now(),
        _startDate,
        _endDate,
      );

      if (widget.editingProject == null) {
        // Thêm mới
        final newId = DateTime.now().millisecondsSinceEpoch;
        context.read<ProjectBloc>().add(
          CreateProjectEvent(
            newId,
            name,
            description,
            _selectedStatus,
            1, // Temporary createdBy value
            timestamp,
          ),
        );
      } else {
        // Cập nhật
        context.read<ProjectBloc>().add(
          UpdateProjectEvent(
            widget.editingProject!.id,
            name,
            description,
            _selectedStatus,
            widget.editingProject!.createdBy,
            timestamp,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.editingProject == null ? "Thêm dự án" : "Chỉnh sửa dự án",
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Tên dự án"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Mô tả"),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Status>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: "Trạng thái"),
                items: Status.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Status? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Ngày bắt đầu"),
                subtitle: Text(_startDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: const Text("Ngày kết thúc"),
                subtitle: Text(_endDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
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


