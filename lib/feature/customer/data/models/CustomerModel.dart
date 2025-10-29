import 'package:project_manager/feature/customer/domain/entities/customer.dart';

class CustomerModel extends Customer {
  CustomerModel(super.id, super.name, super.phone, super.email);

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      json['id'] as int, // Keep as int
      json['name'] ?? '',
      json['phone'] ?? '',
      json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, // Already int, no conversion needed
    'name': name,
    'phone': phone,
    'email': email,
  };
}
