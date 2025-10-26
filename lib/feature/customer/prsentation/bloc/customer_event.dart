import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadCustomersEvent extends CustomerEvent {}

class CreateCustomerEvent extends CustomerEvent {
  final String id;
  final String name;
  final String phone;
  final String email;

  CreateCustomerEvent(this.id, this.name, this.phone, this.email);

  @override
  List<Object?> get props => [id, name, phone, email];
}

class UpdateCustomerEvent extends CustomerEvent {
  final String id;
  final String name;
  final String phone;
  final String email;

  UpdateCustomerEvent(this.id, this.name, this.phone, this.email);

  @override
  List<Object?> get props => [id, name, phone, email];
}

class DeleteCustomerEvent extends CustomerEvent {
  final String id;

  DeleteCustomerEvent(this.id);

  @override
  List<Object?> get props => [id];
}

