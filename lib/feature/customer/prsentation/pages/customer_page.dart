import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_bloc.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_event.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_state.dart';
import 'package:project_manager/feature/customer/prsentation/pages/customer_form.dart';


class CustomerPage extends StatelessWidget {
  final GetCustomerUsecase getCustomerUsecase;
  final CreatecustomerUsecase createCustomerUsecase;
  final UpdateCustomerUsecase updateCustomerUsecase;
  final DeleteCustomerUsecase deleteCustomerUsecase;

  const CustomerPage({
    super.key,
    required this.getCustomerUsecase,
    required this.createCustomerUsecase,
    required this.updateCustomerUsecase,
    required this.deleteCustomerUsecase,
  });

  @override
  Widget build(BuildContext context) {
    // The CustomerBloc is provided at app root (MyApp). Use that instance here.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý khách hàng"),
        centerTitle: true,
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerLoadedState) {
            final customers = state.customers;
            if (customers.isEmpty) {
              return const Center(child: Text("Chưa có khách hàng nào"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(c.name.isNotEmpty ? c.name[0] : '?'),
                    ),
                    title: Text(
                      c.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(c.phone), Text(c.email)],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // show edit dialog; dialog can access the bloc from the app root
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  CustomerFormDialog(editingCustomer: c),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<CustomerBloc>().add(
                              DeleteCustomerEvent(c.id),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CustomerErrorState) {
            return Center(child: Text("Lỗi: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CustomerFormDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
