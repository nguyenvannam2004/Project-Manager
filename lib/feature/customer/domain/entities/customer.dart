import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;

  Customer(this.id, this.name, this.phone, this.email);

  @override
  List<Object?> get props => [id, name, phone, email];
}





