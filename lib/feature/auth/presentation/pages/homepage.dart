// lib/feature/auth/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authstate.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_bloc.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_event.dart';
import 'package:project_manager/feature/customer/prsentation/pages/customer_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final GetCustomerUsecase getcustomerUsecase;
  final DeleteCustomerUsecase deletecustomerUsecase;
  final CreatecustomerUsecase createCustomerUsecase;
  final UpdateCustomerUsecase updateCustomerUsecase;
  const HomePage({
    super.key,
    required this.getcustomerUsecase,
    required this.deletecustomerUsecase,
    required this.createCustomerUsecase,
    required this.updateCustomerUsecase,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    String username = '';
    if (state is AuthAuthenticated) {
      username = state.user.username;
    }

    // Gọi LoadCustomersEvent khi màn hình được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerBloc>().add(LoadCustomersEvent());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: CustomerPage(
          getCustomerUsecase: getcustomerUsecase,
          createCustomerUsecase: createCustomerUsecase,
          updateCustomerUsecase: updateCustomerUsecase,
          deleteCustomerUsecase: deletecustomerUsecase,
        ),
      ),
    );
  }
}
