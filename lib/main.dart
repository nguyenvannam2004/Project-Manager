import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/core/network/customer/ApiFromBackend.dart';
import 'package:project_manager/core/network/customer/IApiClient.dart';

import 'package:project_manager/feature/customer/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/customer/data/repository_ipl/customerrepository_ipl.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_bloc.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_event.dart';
import 'package:project_manager/feature/customer/prsentation/pages/customer_page.dart';

void main() {
  final IApiClient apiClient = ApiFromBackend('https://localhost:7277');
  final RemoteDataSource remoteDataSource = RemoteDataSource(apiClient);
  final CustomerRepositoryIpl customerRepository = CustomerRepositoryIpl(
    remoteDataSource,
  );
  final GetCustomerUsecase getcustomerUsecase = GetCustomerUsecase(
    customerRepository,
  );
  final DeleteCustomerUsecase deletecustomerUsecase = DeleteCustomerUsecase(
    customerRepository,
  );
  final CreatecustomerUsecase createcustomerUsecase = CreatecustomerUsecase(
    customerRepository,
  );
  final UpdateCustomerUsecase updatecustomerUsecase = UpdateCustomerUsecase(
    customerRepository,
  );
  runApp(
    MyApp(
      getcustomerUsecase: getcustomerUsecase,
      deletecustomerUsecase: deletecustomerUsecase,
      createcustomerUsecase: createcustomerUsecase,
      updatecustomerUsecase: updatecustomerUsecase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetCustomerUsecase getcustomerUsecase;
  final DeleteCustomerUsecase deletecustomerUsecase;
  final CreatecustomerUsecase createcustomerUsecase;
  final UpdateCustomerUsecase updatecustomerUsecase;
  const MyApp({
    super.key,
    required this.getcustomerUsecase,
    required this.deletecustomerUsecase,
    required this.createcustomerUsecase,
    required this.updatecustomerUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CustomerBloc(
            getCustomerUsecase: getcustomerUsecase,
            createCustomerUsecase: createcustomerUsecase,
            updateCustomerUsecase: updatecustomerUsecase,
            deleteCustomerUsecase: deletecustomerUsecase,
          )..add(LoadCustomersEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Manager',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: CustomerPage(
          getCustomerUsecase: getcustomerUsecase,
          deleteCustomerUsecase: deletecustomerUsecase,
          createCustomerUsecase: createcustomerUsecase,
          updateCustomerUsecase: updatecustomerUsecase,
        ),
      ),
    );
  }
}
