import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';
import 'package:intl/intl.dart';

class TaskFormPagev2 extends StatefulWidget {
  // 1. Giống file mẫu, nhận 1 task (nếu là chỉnh sửa)
  final Task? editingTask;

  const TaskFormPagev2({super.key, this.editingTask});

  @override
  State<TaskFormPagev2> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPagev2> {
  final _formKey = GlobalKey<FormState>();

  // 2. Tạo controller cho TẤT CẢ các trường
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _stageIdController;
  late TextEditingController _createByController;

  Status _selectedStatus = Status.todo; // Mặc định là 'todo'
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _createdAt; // Cần lưu ngày tạo cũ cho việc update

  @override
  void initState() {
    super.initState();
    // 3. Gán giá trị ban đầu (nếu là update)
    final task = widget.editingTask;
    _nameController = TextEditingController(text: task?.name ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
  _stageIdController = TextEditingController(
    text: task != null ? task.stagedId.toString() : '');
  _createByController = TextEditingController(
    text: task != null ? task.createBy.toString() : '');

    _selectedStatus = task?.status ?? Status.todo;
    
    // Giả định timestamp không null (theo sửa lỗi ở trên)
  // Use safe navigation to avoid calling members on a null Task
  // Note: Task.timeStamp is non-nullable, so only the first null-aware operator is needed
  _startDate = task?.timeStamp.startDate;
  _endDate = task?.timeStamp.endDate;
  _createdAt = task?.timeStamp.createdAt;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stageIdController.dispose();
    _createByController.dispose();
    super.dispose();
  }

  // 4. Hàm _onSave (Logic chính)
  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // Lấy tất cả giá trị từ form
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      
      // Dùng tryParse để an toàn
      final stageId = int.tryParse(_stageIdController.text.trim());
      final createBy = int.tryParse(_createByController.text.trim());

      // Kiểm tra các giá trị bắt buộc
      if (name.isEmpty ||
          description.isEmpty ||
          stageId == null ||
          createBy == null ||
          _startDate == null ||
          _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
        );
        return;
      }
      
      // Kiểm tra logic ngày: start phải <= end
      if (_startDate!.isAfter(_endDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ngày bắt đầu phải trước hoặc bằng ngày kết thúc')),
        );
        return;
      }

      // Kiểm tra số hợp lệ cho stageId và createBy
      if (stageId <= 0 || createBy <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stage ID và Người tạo phải là số nguyên dương')),
        );
        return;
      }

      // Hạn chế độ dài tên/miêu tả
      if (name.length > 200 || description.length > 1000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tên hoặc mô tả quá dài')),
        );
        return;
      }

      final now = DateTime.now();

      if (widget.editingTask == null) {
        // --- THÊM MỚI ---
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
        // --- CẬP NHẬT ---
        // Khi update, dùng ngày tạo cũ, nhưng cập nhật 'updatedAt'
        final timeStamp = TimeStamp(
          _createdAt!, // createdAt (Giữ ngày tạo gốc)
          now, // updatedAt (Cập nhật ngày mới)
          _startDate!,
          _endDate!,
        );

        context.read<TaskBloc>().add(
              UpdateTaskEvent(
                widget.editingTask!.id, // Dùng ID cũ
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
  }

  // Hàm trợ giúp chọn ngày
  Future<void> _pickDate(bool isStartDate) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? now,
      firstDate: now.subtract(Duration(days: 365)),
      lastDate: now.add(Duration(days: 365)),
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

  @override
  Widget build(BuildContext context) {
    // 5. Trả về 1 trang (Scaffold) thay vì Dialog
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editingTask == null ? "Thêm Task mới" : "Chỉnh sửa Task",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _onSave,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Tên Task"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Mô tả"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _stageIdController,
                decoration: const InputDecoration(labelText: "Stage ID"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _createByController,
                decoration: const InputDecoration(labelText: "Người tạo (ID)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Không được để trống" : null,
              ),
              SizedBox(height: 12),
              // Dropdown cho Status
              DropdownButtonFormField<Status>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: "Trạng thái"),
                items: Status.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last), // Hiển thị 'todo', 'done'
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              // Chọn ngày
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate == null
                        ? "Chưa chọn ngày bắt đầu"
                        : "Bắt đầu: ${DateFormat('dd/MM/yyyy').format(_startDate!)}",
                  ),
                  TextButton(
                    child: Text("Chọn ngày"),
                    onPressed: () => _pickDate(true),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate == null
                        ? "Chưa chọn ngày kết thúc"
                        : "Kết thúc: ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                  ),
                  TextButton(
                    child: Text("Chọn ngày"),
                    onPressed: () => _pickDate(false),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _onSave,
                child: Text("Lưu Task"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


