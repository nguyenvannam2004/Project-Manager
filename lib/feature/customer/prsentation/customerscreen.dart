import 'package:flutter/material.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/customer/prsentation/customer_form_dialog.dart';

class CustomerScreen extends StatefulWidget {
  final GetCustomerUsecase getCustomerUsecase;
  final UpdateCustomerUsecase updateCustomerUsecase;
  final DeleteCustomerUsecase deleteCustomerUsecase;
  final CreatecustomerUsecase createCustomerUsecase;

  const CustomerScreen({
    super.key,
    required this.getCustomerUsecase,
    required this.updateCustomerUsecase,
    required this.deleteCustomerUsecase,
    required this.createCustomerUsecase,
  });

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> _customers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  // ==== LOAD DATA ====
  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);
    try {
      final data = await widget.getCustomerUsecase.call();
      setState(() => _customers = data);
    } catch (e) {
      _showSnack("Lỗi khi tải dữ liệu: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ==== MỞ FORM ====
  Future<void> _openCustomerForm({Customer? editing}) async {
    final result = await showDialog<Customer>(
      context: context,
      builder: (context) => CustomerFormDialog(editingCustomer: editing),
    );

    if (result != null) {
      if (editing == null) {
        await _addCustomer(result);
      } else {
        await _updateCustomer(result);
      }
    }
  }

  // ==== CRUD ====
  Future<void> _addCustomer(Customer customer) async {
    setState(() => _isLoading = true);
    try {
      await widget.createCustomerUsecase.call(
        customer.id,
        customer.name,
        customer.email,
        customer.phone,
      );
      await _loadCustomers();
      _showSnack("Đã thêm khách hàng!");
    } catch (e) {
      _showSnack("Lỗi khi thêm khách hàng: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateCustomer(Customer customer) async {
    setState(() => _isLoading = true);
    try {
      await widget.updateCustomerUsecase.call(
        customer.id,
        customer.name,
        customer.email,
        customer.phone,
      );
      await _loadCustomers();
      _showSnack("Đã cập nhật thông tin!");
    } catch (e) {
      _showSnack("Lỗi khi cập nhật: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCustomer(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa khách hàng'),
        content: const Text('Bạn có chắc muốn xóa khách hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await widget.deleteCustomerUsecase.call(id);
        await _loadCustomers();
        _showSnack("Đã xóa khách hàng!");
      } catch (e) {
        _showSnack("Lỗi khi xóa: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // ==== SNACK ====
  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ==== UI ====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý khách hàng')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCustomerForm(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCustomers,
              child: _customers.isEmpty
                  ? const Center(child: Text('Chưa có khách hàng nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _customers.length,
                      itemBuilder: (context, index) {
                        final c = _customers[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              c.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(c.phone), Text(c.email)],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () =>
                                      _openCustomerForm(editing: c),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCustomer(c.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
