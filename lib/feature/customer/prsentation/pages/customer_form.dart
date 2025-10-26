import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_bloc.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_event.dart';


class CustomerFormDialog extends StatefulWidget {
  final Customer? editingCustomer;

  const CustomerFormDialog({super.key, this.editingCustomer});

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.editingCustomer?.name ?? '',
    );
    _emailController = TextEditingController(
      text: widget.editingCustomer?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.editingCustomer?.phone ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      if (name.isEmpty || email.isEmpty || phone.isEmpty) {
        print('Error: Empty fields detected'); // Debug
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
        );
        return;
      }
      print('Editing customer: ${widget.editingCustomer}'); // Debug
      if (widget.editingCustomer == null) {
        // Thêm mới
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        context.read<CustomerBloc>().add(
          CreateCustomerEvent(newId, name, phone, email),
        );
      } else {
        context.read<CustomerBloc>().add(
          UpdateCustomerEvent(widget.editingCustomer!.id, name, phone, email),
        );
      }
      Navigator.of(context).pop();
    } else {
      print('Form validation failed'); // Debug
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.editingCustomer == null
            ? "Thêm khách hàng"
            : "Chỉnh sửa khách hàng",
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Tên khách hàng"),
              validator: (v) =>
                  v == null || v.isEmpty ? "Không được để trống" : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (v) =>
                  v == null || v.isEmpty ? "Không được để trống" : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Số điện thoại"),
              validator: (v) =>
                  v == null || v.isEmpty ? "Không được để trống" : null,
            ),
          ],
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
