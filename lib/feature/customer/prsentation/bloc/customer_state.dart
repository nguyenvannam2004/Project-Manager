import 'package:equatable/equatable.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';

abstract class CustomerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomerInitialState extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final List<Customer> customers;

  CustomerLoadedState(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomerErrorState extends CustomerState {
  final String message;

  CustomerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}