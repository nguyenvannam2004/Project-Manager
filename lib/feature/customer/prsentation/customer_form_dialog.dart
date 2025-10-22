import 'package:flutter/material.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';

class CustomerFormDialog extends StatefulWidget {
  final Customer? editingCustomer;

  const CustomerFormDialog({super.key, this.editingCustomer});

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editingCustomer?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.editingCustomer?.phone ?? '');
    _emailCtrl = TextEditingController(text: widget.editingCustomer?.email ?? '');
    if (widget.editingCustomer != null) {
      _nameCtrl.text = widget.editingCustomer!.name;
      _emailCtrl.text = widget.editingCustomer!.email;
      _phoneCtrl.text = widget.editingCustomer!.phone;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final id = widget.editingCustomer?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final newCustomer = Customer(
        id,
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _phoneCtrl.text.trim(),
        
      );
      Navigator.pop(context, newCustomer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editingCustomer == null ? 'Thêm khách hàng' : 'Sửa khách hàng'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên khách hàng'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Vui lòng nhập số điện thoại' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
                  if (!v.contains('@')) return 'Email không hợp lệ';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: Text(widget.editingCustomer == null ? 'Thêm' : 'Lưu'),
        ),
      ],
    );
  }
}
