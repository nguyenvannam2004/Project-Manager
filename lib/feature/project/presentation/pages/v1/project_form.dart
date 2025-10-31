import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/feature/project/domain/entities/project.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_bloc.dart';
import 'package:project_manager/feature/project/presentation/bloc/project_event.dart';

class ProjectFormDialog extends StatefulWidget {
  final Project? editingProject;

  const ProjectFormDialog({super.key, this.editingProject});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  // Thêm Controller cho ngày tháng
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  Status _selectedStatus = Status.pending;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  bool get _isEditing => widget.editingProject != null;

  @override
  void initState() {
    super.initState();

    // Khởi tạo text cho controller
    _nameController = TextEditingController(
      text: widget.editingProject?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.editingProject?.description ?? '',
    );

    // Gán giá trị nếu đang chỉnh sửa
    if (_isEditing) {
      _selectedStatus = widget.editingProject!.status;
      _startDate = widget.editingProject!.timestamp.startDate ?? DateTime.now();
      _endDate =
          widget.editingProject!.timestamp.endDate ??
          DateTime.now().add(const Duration(days: 7));
    }

    // Khởi tạo controller cho ngày tháng (phải sau khi gán _startDate)
    _startDateController = TextEditingController(text: _formatDate(_startDate));
    _endDateController = TextEditingController(text: _formatDate(_endDate));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // Hàm format ngày tháng
  String _formatDate(DateTime date) {
    // Định dạng lại thành dd/MM/yyyy
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Hàm chọn ngày - Cập nhật để set text cho controller
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
          _startDateController.text = _formatDate(picked);
        } else {
          _endDate = picked;
          _endDateController.text = _formatDate(picked);
        }
      });
    }
  }

  // Hàm lấy màu theo trạng thái (giống trong project_page.dart)
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

  // Hàm lấy text Tiếng Việt cho trạng thái
  String _getStatusText(Status status) {
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
        return 'Không xác định';
    }
  }

  // Widget cho item của Dropdown
  Widget _buildStatusItem(Status status) {
    return Row(
      children: [
        Icon(Icons.circle, color: _getStatusColor(status), size: 14),
        const SizedBox(width: 8),
        Text(_getStatusText(status)),
      ],
    );
  }

  // Hàm lưu (không thay đổi logic, chỉ thay đổi tên biến)
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

  // ----- PHẦN BUILD UI CHÍNH -----
  @override
  Widget build(BuildContext context) {
    // Đây là style chung cho các input
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[50], // Màu nền nhạt cho input
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // Không viền
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[300]!), // Viền mờ
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ), // Viền khi focus
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),
    );

    // Đổi AlertDialog thành Dialog
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: 500, // Giới hạn chiều rộng của dialog
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- PHẦN TIÊU ĐỀ (HEADER) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            _isEditing ? Icons.edit_outlined : Icons.add,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing ? "Chỉnh sửa dự án" : "Thêm dự án mới",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _isEditing
                                  ? "Cập nhật thông tin dự án"
                                  : "Tạo dự án mới",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.grey[500],
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // --- CÁC TRƯỜNG FORM ---
                // Đổi tên label cho khớp ảnh
                const Text(
                  "Tên dự án",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _nameController,
                  decoration: inputDecoration.copyWith(
                    hintText: "Nhập tên dự án",
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Không được để trống" : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  "Mô tả",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: inputDecoration.copyWith(
                    hintText: "Nhập mô tả chi tiết",
                  ),
                  maxLines: 3,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Không được để trống" : null,
                ),
                const SizedBox(height: 16),

                // --- HÀNG NGÀY BẮT ĐẦU VÀ KẾT THÚC ---
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ngày bắt đầu",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8.0),
                          // Đổi ListTile thành TextFormField
                          TextFormField(
                            controller: _startDateController,
                            decoration: inputDecoration.copyWith(
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey[600],
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context, true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ngày kết thúc",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8.0),
                          // Đổi ListTile thành TextFormField
                          TextFormField(
                            controller: _endDateController,
                            decoration: inputDecoration.copyWith(
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey[600],
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context, false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- TRẠNG THÁI ---
                const Text(
                  "Trạng thái",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                DropdownButtonFormField<Status>(
                  value: _selectedStatus,
                  decoration: inputDecoration,
                  // Dùng selectedItemBuilder để hiển thị item đã chọn
                  selectedItemBuilder: (context) {
                    return Status.values.map((status) {
                      return _buildStatusItem(status);
                    }).toList();
                  },
                  // Dùng items cho danh sách dropdown
                  items: Status.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: _buildStatusItem(status),
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
                const SizedBox(height: 24.0),

                // --- CÁC NÚT HÀNH ĐỘNG ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(color: Colors.black87),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Đổi ElevatedButton thành FilledButton.icon
                    FilledButton.icon(
                      onPressed: _onSave,
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.add,
                        size: 18.0,
                      ),
                      label: Text(_isEditing ? "Cập nhật" : "Tạo mới"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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
