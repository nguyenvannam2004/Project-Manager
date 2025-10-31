// lib/feature/stages/presentation/pages/stage_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/core/entities/status.dart';
import 'package:project_manager/core/utils/project_utils.dart';
import 'package:project_manager/feature/stages/domain/entities/stage.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_bloc.dart';
import 'package:project_manager/feature/stages/presentation/bloc/stage_event.dart';

class StageFormDialogv3 extends StatefulWidget {
  final Stage? editingStage;
  final int projectId;
  const StageFormDialogv3({super.key, this.editingStage, required this.projectId});

  @override
  State<StageFormDialogv3> createState() => _StageFormDialogState();
}

class _StageFormDialogState extends State<StageFormDialogv3> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _descCtrl;
  DateTime? _start, _end;
  Status _status = Status.pending;
  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editingStage?.name ?? '');
    _descCtrl = TextEditingController(text: widget.editingStage?.description ?? '');
    _start = widget.editingStage?.timestamps.startDate;
    _end = widget.editingStage?.timestamps.endDate;
    _status = widget.editingStage?.status ?? Status.pending;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày bắt đầu và kết thúc')));
      }
      return;
    }

    final now = DateTime.now();
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (widget.editingStage == null) {
      final id = DateTime.now().millisecondsSinceEpoch;
      context.read<StageBloc>().add(CreateStageEvent(
        id: id, name: name, projectId: widget.projectId, description: desc,
        startDate: _start!, endDate: _end!, status: _status, createdAt: now, updatedAt: now,
      ));
    } else {
      context.read<StageBloc>().add(UpdateStageEvent(
        id: widget.editingStage!.id, name: name, projectId: widget.editingStage!.projectId,
        description: desc, startDate: _start!, endDate: _end!, status: _status,
        createdAt: widget.editingStage!.timestamps.createdAt, updatedAt: now,
      ));
    }
    Navigator.of(context).pop();
  }

  InputDecoration _dec(ColorScheme cs, String label, String hint) {
    return InputDecoration(
      labelText: label, hintText: hint, filled: true, fillColor: cs.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.outline.withOpacity(0.5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: cs.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isEdit = widget.editingStage != null;

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
                Text(isEdit ? "Chỉnh sửa giai đoạn" : "Thêm giai đoạn mới", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onPrimaryContainer)),
                const SizedBox(height: 4),
                Text(isEdit ? "Cập nhật thông tin giai đoạn" : "Tạo giai đoạn cho dự án", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onPrimaryContainer.withOpacity(0.7))),
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
                  TextFormField(controller: _nameCtrl, decoration: _dec(cs, "Tên giai đoạn", "Nhập tên giai đoạn"), validator: (v) => v?.isEmpty ?? true ? "Vui lòng nhập tên" : null),
                  const SizedBox(height: 20),
                  TextFormField(controller: _descCtrl, decoration: _dec(cs, "Mô tả", "Nhập mô tả chi tiết"), maxLines: 4),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: TextFormField(readOnly: true, onTap: () => _pick(true), controller: TextEditingController(text: _start != null ? _fmt.format(_start!) : ""), decoration: _dec(cs, "Ngày bắt đầu", "Chọn ngày").copyWith(suffixIcon: Icon(Icons.calendar_today_rounded, color: cs.primary)))),
                    const SizedBox(width: 16),
                    Expanded(child: TextFormField(readOnly: true, onTap: () => _pick(false), controller: TextEditingController(text: _end != null ? _fmt.format(_end!) : ""), decoration: _dec(cs, "Ngày kết thúc", "Chọn ngày").copyWith(suffixIcon: Icon(Icons.calendar_today_rounded, color: cs.primary)))),
                  ]),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Status>(
                    value: _status,
                    decoration: _dec(cs, "Trạng thái", "").copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                    items: Status.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Row(children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: ProjectUtils.statusColor(s), shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Text(ProjectUtils.statusText(s)),
                      ]),
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