// // lib/feature/auth/presentation/pages/login_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:project_manager/feature/auth/presentation/bloc/authbloc.dart';
// import 'package:project_manager/feature/auth/presentation/bloc/authevent.dart';
// import 'package:project_manager/feature/auth/presentation/bloc/authstate.dart';
// import 'package:project_manager/feature/auth/presentation/pages/homepage.dart';
// import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
// import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
// import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
// import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
// import 'package:project_manager/feature/project/domain/usecase/createproject_usecase.dart';
// import 'package:project_manager/feature/project/domain/usecase/deleteproject_usecase.dart';
// import 'package:project_manager/feature/project/domain/usecase/getproject_usecase.dart';
// import 'package:project_manager/feature/project/domain/usecase/updateproject_usecase.dart';
// import 'package:project_manager/feature/project/presentation/pages/project_page.dart';
// import 'package:project_manager/feature/stages/domain/usecases/createStage_usecase.dart';
// import 'package:project_manager/feature/stages/domain/usecases/deleteStage_usecase.dart';
// import 'package:project_manager/feature/stages/domain/usecases/getStage_usecase.dart';
// import 'package:project_manager/feature/stages/domain/usecases/updateStage_usecase.dart';
// import 'package:project_manager/feature/stages/presentation/pages/stage_page.dart';
// import 'package:project_manager/feature/task/domain/usecase/createtask_usecase.dart';
// import 'package:project_manager/feature/task/domain/usecase/deletetask_usecase.dart';
// import 'package:project_manager/feature/task/domain/usecase/gettask_usecase.dart';
// import 'package:project_manager/feature/task/domain/usecase/updatetask_usecase.dart';
// import 'package:project_manager/feature/task/presentation/pages/task_page.dart';


// class LoginPage extends StatefulWidget {
//   // final GetTaskUsecase getTaskUseCase;
//   // final CreateTaskUsecase createTaskUseCase;
//   // final UpdateTaskUsecase updateTaskUseCase;
//   // final DeleteTaskUsecase deleteTaskUseCase;
  
//   // final GetCustomerUsecase getcustomerUsecase;
//   // final DeleteCustomerUsecase deletecustomerUsecase;
//   // final CreatecustomerUsecase createCustomerUsecase;
//   // final UpdateCustomerUsecase updateCustomerUsecase;

//   // final GetProjectUsecase getProjectUsecase;
//   // final UpdateProjectUsecase updateProjectUsecase;
//   // final DeleteProjectUsecase deleteProjectUsecase;
//   // final CreateProjectUsecase createProjectUsecase;

//   // final GetStageUsecase getStageUsecase;
//   // final DeletestageUsecase deleteStageUsecase;
//   // final CreateStageUsecase createStageUsecase;
//   // final UpdateStageUsecase updateStageUsecase;


//   const LoginPage({super.key, 

  
//   // required this.getcustomerUsecase,
//   // required this.deletecustomerUsecase,
//   // required this.createCustomerUsecase,
//   // required this.updateCustomerUsecase,

//   // required this.updateProjectUsecase,
//   // required this.getProjectUsecase,
//   // required this.deleteProjectUsecase,
//   // required this.createProjectUsecase,

//   // required this.getStageUsecase, 
//   // required this.deleteStageUsecase, 
//   // required this.createStageUsecase, 
//   // required this.updateStageUsecase, 
  
//   // required this.getTaskUseCase, 
//   // required this.createTaskUseCase, 
//   // required this.updateTaskUseCase, 
//   // required this.deleteTaskUseCase, 

// });

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
  
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthAuthenticated) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => ProjectPage(
//               )),
//             );
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AuthLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
//                 TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<AuthBloc>().add(
//                           LoginRequested(usernameController.text, passwordController.text),
//                         );
//                   },
//                   child: const Text('Login'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/register');
//                   },
//                   child: const Text('Register'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



// lib/feature/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authstate.dart';
import 'package:project_manager/feature/project/presentation/pages/project_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProjectPage()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspaces_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Project Manager',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đăng nhập để tiếp tục',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Username Field
                  _CleanTextField(
                    controller: usernameController,
                    hintText: 'Tên đăng nhập',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  _CleanTextField(
                    controller: passwordController,
                    hintText: 'Mật khẩu',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  if (state is AuthLoading)
                    const CircularProgressIndicator(color: Color(0xFF6366F1))
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              usernameController.text.trim(),
                              passwordController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Register Link
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Chưa có tài khoản? Đăng ký',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Clean, Professional TextField
class _CleanTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;

  const _CleanTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }
}