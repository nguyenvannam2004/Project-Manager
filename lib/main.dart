import 'package:flutter/material.dart';
import 'package:project_manager/core/network/customer/apiclient.dart';
import 'package:project_manager/feature/customer/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/customer/data/repository_ipl/customerrepository_ipl.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';

import 'package:project_manager/feature/customer/prsentation/statefullwidget_setstate/customerpage.dart';

void main() {
  final ApiClient apiClient = ApiClient();
  final RemoteDataSource remoteDataSource = RemoteDataSource(apiClient);
  final CustomerRepository customerRepository = CustomerRepositoryIpl(
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: CustomerPage(
        getcustomerUsecase: getcustomerUsecase,
        deletecustomerUsecase: deletecustomerUsecase,
        createcustomerUsecase: createcustomerUsecase,
        updatecustomerUsecase: updatecustomerUsecase,
      ),
    );
  }
}
