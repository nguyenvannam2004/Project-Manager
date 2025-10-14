import 'package:project_manager/feature/customer/domain/entities/customer.dart';

class CustomerModel extends Customer
{
  CustomerModel(super.id, super.name, super.phone, super.email);

  factory CustomerModel.fromJson(Map<String, dynamic> json, String id) {
    return CustomerModel(
      id,
      json['name'] as String? ?? '',
      json['phone'] as String? ?? '',
      json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone, 'email': email};
}