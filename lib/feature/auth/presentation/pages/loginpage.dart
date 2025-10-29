// lib/feature/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authstate.dart';
import 'package:project_manager/feature/auth/presentation/pages/homepage.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';


class LoginPage extends StatefulWidget {
  final GetCustomerUsecase getcustomerUsecase;
  final DeleteCustomerUsecase deletecustomerUsecase;
  final CreatecustomerUsecase createCustomerUsecase;
  final UpdateCustomerUsecase updateCustomerUsecase;
  const LoginPage({super.key, required this.getcustomerUsecase, 
  required this.deletecustomerUsecase, 
  required this.createCustomerUsecase, 
  required this.updateCustomerUsecase});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(getcustomerUsecase: widget.getcustomerUsecase, 
              deletecustomerUsecase: widget.deletecustomerUsecase, 
              createCustomerUsecase: widget.createCustomerUsecase, 
              updateCustomerUsecase: widget.updateCustomerUsecase)),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
                TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          LoginRequested(usernameController.text, passwordController.text),
                        );
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
