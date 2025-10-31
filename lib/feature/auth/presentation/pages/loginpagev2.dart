// lib/feature/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authstate.dart';
import 'package:project_manager/feature/auth/presentation/pages/homepage.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
import 'package:project_manager/feature/project/presentation/pages/v1/project_page.dart';
import 'package:project_manager/feature/project/presentation/pages/v2/project_pagev2.dart';
import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
import 'package:project_manager/feature/stages/presentation/pages/v1/stage_page.dart';
import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
import 'package:project_manager/feature/task/presentation/pages/v1/task_page.dart';


class LoginPagev2 extends StatefulWidget {
  // final GetTaskUsecase getTaskUseCase;
  // final CreateTaskUsecase createTaskUseCase;
  // final UpdateTaskUsecase updateTaskUseCase;
  // final DeleteTaskUsecase deleteTaskUseCase;
  
  // final GetCustomerUsecase getcustomerUsecase;
  // final DeleteCustomerUsecase deletecustomerUsecase;
  // final CreatecustomerUsecase createCustomerUsecase;
  // final UpdateCustomerUsecase updateCustomerUsecase;

  // final GetProjectUsecase getProjectUsecase;
  // final UpdateProjectUsecase updateProjectUsecase;
  // final DeleteProjectUsecase deleteProjectUsecase;
  // final CreateProjectUsecase createProjectUsecase;

  // final GetStageUsecase getStageUsecase;
  // final DeletestageUsecase deleteStageUsecase;
  // final CreateStageUsecase createStageUsecase;
  // final UpdateStageUsecase updateStageUsecase;


  const LoginPagev2({super.key, 

  
  // required this.getcustomerUsecase,
  // required this.deletecustomerUsecase,
  // required this.createCustomerUsecase,
  // required this.updateCustomerUsecase,

  // required this.updateProjectUsecase,
  // required this.getProjectUsecase,
  // required this.deleteProjectUsecase,
  // required this.createProjectUsecase,

  // required this.getStageUsecase, 
  // required this.deleteStageUsecase, 
  // required this.createStageUsecase, 
  // required this.updateStageUsecase, 
  
  // required this.getTaskUseCase, 
  // required this.createTaskUseCase, 
  // required this.updateTaskUseCase, 
  // required this.deleteTaskUseCase, 

});

  @override
  State<LoginPagev2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPagev2> {
  
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
              MaterialPageRoute(builder: (context) => ProjectPagev2()),
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
