// lib/feature/task/presentation/pages/task_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/entities/timestamp.dart';
import 'package:project_manager/core/utils/project_utils.dart';
import 'package:project_manager/feature/task/domain/entities/task.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_bloc.dart';
import 'package:project_manager/feature/task/presentation/bloc/task_event.dart';

class TaskFormDialogv3 extends StatefulWidget {
  final Task? editingTask;
  final int stageId;
  const TaskFormDialogv3({super.key, this.editingTask, required this.stageId});

  @override
  State<TaskFormDialogv3> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialogv3> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _descCtrl, _stageIdCtrl, _createByCtrl;
  DateTime? _start, _end;
  Status _status = Status.todo;
  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editingTask?.name ?? '');
    _descCtrl = TextEditingController(text: widget.editingTask?.description ?? '');
    _stageIdCtrl = TextEditingController(text: widget.editingTask?.stagedId.toString() ?? widget.stageId.toString());
    _createByCtrl = TextEditingController(text: widget.editingTask?.createBy.toString() ?? '1');
    _start = widget.editingTask?.timeStamp.startDate;
    _end = widget.editingTask?.timeStamp.endDate;
    _status = widget.editingTask?.status ?? Status.todo;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _stageIdCtrl.dispose();
    _createByCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick(bool isStart) async {
    final init = isStart ? (_start ?? DateTime.now()) : (_end ?? DateTime.now());
    final picked = await showDatePicker(context: context, initialDate: init, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) setState(() => isStart ? _start = picked : _end = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _start == null || _end == null) {
      if (_start == null || _end == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày')));
      }
      return;
    }

    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final stageId = int.tryParse(_stageIdCtrl.text.trim()) ?? widget.stageId;
    final createBy = int.tryParse(_createByCtrl.text.trim()) ?? 1;
    final now = DateTime.now();
    final ts = TimeStamp(
      widget.editingTask?.timeStamp.createdAt ?? now,
      now,
      _start!,
      _end!,
    );

    if (widget.editingTask == null) {
      final id = DateTime.now().millisecondsSinceEpoch;
      context.read<TaskBloc>().add(CreateTaskEvent(id, stageId, name, desc, _status, createBy, ts));
    } else {
      context.read<TaskBloc>().add(UpdateTaskEvent(widget.editingTask!.id, stageId, name, desc, _status, createBy, ts));
    }
    Navigator.of(context).pop();
  }

  InputDecoration _dec(ColorScheme cs, String label, String hint, {IconData? icon}) {
    return InputDecoration(
      labelText: label, hintText: hint, filled: true, fillColor: cs.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline.withOpacity(0.5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: icon != null ? Icon(icon, color: cs.primary) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isEdit = widget.editingTask != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(12)), child: Icon(isEdit ? Icons.edit_rounded : Icons.add_rounded, color: cs.onPrimary, size: 24)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(isEdit ? "Chỉnh sửa Task" : "Thêm Task mới", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onPrimaryContainer)),
                const SizedBox(height: 4),
                Text(isEdit ? "Cập nhật thông tin Task" : "Tạo một Task mới", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onPrimaryContainer.withOpacity(0.7))),
              ])),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded), color: cs.onPrimaryContainer),
            ]),
          ),

          // Form
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  TextFormField(controller: _nameCtrl, decoration: _dec(cs, "Tên Task", "Nhập tên Task"), validator: (v) => v?.isEmpty ?? true ? "Vui lòng nhập tên" : null),
                  const SizedBox(height: 20),
                  TextFormField(controller: _descCtrl, decoration: _dec(cs, "Mô tả", "Nhập mô tả chi tiết"), maxLines: 4),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: TextFormField(controller: _stageIdCtrl, decoration: _dec(cs, "Stage ID", "Nhập ID"), keyboardType: TextInputType.number, validator: (v) => v?.isEmpty ?? true ? "Nhập ID" : null)),
                    const SizedBox(width: 16),
                    Expanded(child: TextFormField(controller: _createByCtrl, decoration: _dec(cs, "Người tạo (ID)", "Nhập ID"), keyboardType: TextInputType.number, validator: (v) => v?.isEmpty ?? true ? "Nhập ID" : null)),
                  ]),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: TextFormField(readOnly: true, onTap: () => _pick(true), controller: TextEditingController(text: _start != null ? _fmt.format(_start!) : ""), decoration: _dec(cs, "Ngày bắt đầu", "Chọn ngày", icon: Icons.calendar_today_rounded))),
                    const SizedBox(width: 16),
                    Expanded(child: TextFormField(readOnly: true, onTap: () => _pick(false), controller: TextEditingController(text: _end != null ? _fmt.format(_end!) : ""), decoration: _dec(cs, "Ngày kết thúc", "Chọn ngày", icon: Icons.calendar_today_rounded))),
                  ]),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Status>(
                    value: _status,
                    decoration: _dec(cs, "Trạng thái", "", icon: null).copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                    items: Status.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: ProjectUtils.statusColor(s), shape: BoxShape.circle)), const SizedBox(width: 12), Text(ProjectUtils.statusText(s))]),
                    )).toList(),
                    onChanged: (v) => v != null ? setState(() => _status = v) : null,
                  ),
                ]),
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: cs.surfaceContainerHighest.withOpacity(0.3), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Hủy")),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: Text(isEdit ? "Cập nhật" : "Tạo mới"),
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}