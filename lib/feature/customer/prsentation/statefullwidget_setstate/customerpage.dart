import 'package:flutter/material.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/customer/prsentation/customer_form_dialog.dart';

class CustomerPage extends StatefulWidget {
  final GetCustomerUsecase getcustomerUsecase;
  final DeleteCustomerUsecase deletecustomerUsecase;
  final CreatecustomerUsecase createcustomerUsecase;
  final UpdateCustomerUsecase updatecustomerUsecase;

  const CustomerPage({
    super.key,
    required this.getcustomerUsecase,
    required this.deletecustomerUsecase,
    required this.createcustomerUsecase,
    required this.updatecustomerUsecase,
  });

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer> customers = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await widget.getcustomerUsecase.call();
      setState(() {
        customers = data;
      });
    } catch (e) {
      // Handle error, e.g., show a snackbar
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteCustomer(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() {
        isLoading = true;
      });
      try {
        await widget.deletecustomerUsecase.call(id);
        await _loadCustomers();
      } catch (e) {
        // Handle error, e.g., show a snackbar
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _createCustomer() async {
    final newcustomer = await showDialog<Customer>(
      context: context,
      builder: (context) => CustomerFormDialog(),
    );
    
    if (newcustomer != null) {
      await widget.createcustomerUsecase.call(newcustomer.id, newcustomer.name, newcustomer.phone, newcustomer.email);  
      await _loadCustomers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm khách hàng mới')),
      );
    }
  }

  Future <void> _editCustomer(String id) async {
    final existingCustomer =
        customers.firstWhere((customer) => customer.id == id);
    final updatedCustomer = await showDialog<Customer>(
      context: context,
      builder: (context) => CustomerFormDialog(
        editingCustomer: existingCustomer,
      ),
    );

    if (updatedCustomer != null) {
      setState(() {
        isLoading = true;
      });
      try {
        await widget.updatecustomerUsecase.call(
          updatedCustomer.id,
          updatedCustomer.name,
          updatedCustomer.phone,
          updatedCustomer.email,
        );
        await _loadCustomers();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật khách hàng')),
        );
      } catch (e) {
        // Handle error, e.g., show a snackbar
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách khách hàng'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _createCustomer,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text(
                'Thêm khách hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customers.isEmpty
          ? const Center(child: Text('Không có khách hàng nào'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.shade100,
                      child: Text(
                        c.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      c.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('${c.phone} | ${c.email}'),
                    trailing: Row( 
                      mainAxisSize: MainAxisSize.min, 
                      children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editCustomer(c.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteCustomer(c.id),
                      ),
                    ],)  
                  ),
                );
              },
            ),
    );
  }
}
