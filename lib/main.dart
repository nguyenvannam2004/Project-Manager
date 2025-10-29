import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/network/auth/ApiFromBackend.dart';
import 'package:project_manager/core/network/auth/IApiclient.dart';
import 'package:project_manager/feature/auth/presentation/pages/registerpage.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_bloc.dart';
// import 'package:project_manager/core/network/customer/apiclient.dart';
import 'package:project_manager/feature/auth/data/datasource/AuthRemoteDataSource.dart';
import 'package:project_manager/feature/auth/data/repository_ipl/authrepository_ipl.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';
import 'package:project_manager/feature/auth/domain/usecase/LoginUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/LogoutUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/RegisterUsecase.dart';
import 'package:project_manager/feature/auth/presentation/bloc/authbloc.dart';
import 'package:project_manager/feature/auth/presentation/pages/loginpage.dart';
import 'package:project_manager/feature/customer/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/customer/data/repository_ipl/customerrepository_ipl.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
// import 'package:project_manager/feature/customer/data/datasource/remotedatasource.dart';
// import 'package:project_manager/feature/customer/data/repository_ipl/customerrepository_ipl.dart';
// import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';
// import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
// import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
// import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
// import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';

void main() {
  
  final IApiClient apiClient = ApiClientfrombackend('https://localhost:7277');
  final AuthRemoteDataSource authremoteDataSource = AuthRemoteDataSource(
    apiClient,
  );

  

  /// chức năng login
  final AuthRepository authRepository = AuthRepositoryImpl(
    authremoteDataSource,
  );
  final LoginUseCase loginUseCase = LoginUseCase(authRepository);
  final LogoutUseCase logoutUseCase = LogoutUseCase(authRepository);
  final RegisterUseCase registerUseCase = RegisterUseCase(authRepository);




  // chức năng liên quan tới tài nguyên khách hàng
  final RemoteDataSource remotedatasrc = RemoteDataSource(apiClient);
  final CustomerRepository customerRepository = CustomerRepositoryIpl(
    remotedatasrc,
  );
  final GetCustomerUsecase getcustomerUsecase = GetCustomerUsecase(
    customerRepository,
  );
  final DeleteCustomerUsecase deletecustomerUsecase = DeleteCustomerUsecase(
    customerRepository,
  );
  final CreatecustomerUsecase createCustomerUsecase = CreatecustomerUsecase(
    customerRepository,
  );
  final UpdateCustomerUsecase updateCustomerUsecase = UpdateCustomerUsecase(
    customerRepository,
  );

  runApp(
    MyApp(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
      registerUseCase: registerUseCase,

      getcustomerUsecase: getcustomerUsecase,
      deletecustomerUsecase: deletecustomerUsecase,
      createCustomerUsecase: createCustomerUsecase,
      updateCustomerUsecase: updateCustomerUsecase,
    ),
  );
}

class MyApp extends StatelessWidget {
  // customer
  final GetCustomerUsecase getcustomerUsecase;
  final DeleteCustomerUsecase deletecustomerUsecase;
  final CreatecustomerUsecase createCustomerUsecase;
  final UpdateCustomerUsecase updateCustomerUsecase;


  // auth
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,

    required this.getcustomerUsecase,
    required this.deletecustomerUsecase,
    required this.createCustomerUsecase,
    required this.updateCustomerUsecase,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              loginUseCase: loginUseCase,
              logoutUseCase: logoutUseCase,
              registerUseCase: registerUseCase,
            ),
          ),
          BlocProvider(
            create: (context) => CustomerBloc(
              getCustomerUsecase: getcustomerUsecase,
              deleteCustomerUsecase: deletecustomerUsecase,
              createCustomerUsecase: createCustomerUsecase,
              updateCustomerUsecase: updateCustomerUsecase,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: LoginPage(
            getcustomerUsecase: getcustomerUsecase,
            deletecustomerUsecase: deletecustomerUsecase,
            createCustomerUsecase: createCustomerUsecase,
            updateCustomerUsecase: updateCustomerUsecase,
          ),

          routes: {
            '/register': (context) => RegisterPage(), 
          },
          
        ),
      );
  }
}
