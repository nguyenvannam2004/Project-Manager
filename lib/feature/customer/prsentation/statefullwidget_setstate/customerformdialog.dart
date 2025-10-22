import 'package:flutter/material.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';

class CustomerFormDialog extends StatefulWidget
{
  final Customer? editingCustomer;

  const CustomerFormDialog({super.key, this.editingCustomer}); 
  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
  
}

class _CustomerFormDialogState extends State<CustomerFormDialog>
{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.editingCustomer != null) {
      _nameController.text = widget.editingCustomer!.name;
      _emailController.text = widget.editingCustomer!.email;
      _phoneController.text = widget.editingCustomer!.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingCustomer != null;

    return AlertDialog(
      title: Text(isEditing ? 'Chỉnh sửa khách hàng' : 'Thêm khách hàng mới'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên khách hàng'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final customer = Customer(
                widget.editingCustomer?.id ?? '', // giữ id nếu đang sửa
                _nameController.text.trim(),
                _phoneController.text.trim(),
                _emailController.text.trim(),
              );
              Navigator.pop(context, customer);
            }
          },
          child: Text(isEditing ? 'Lưu thay đổi' : 'Thêm'),
        ),
      ],
    );
  }
}