import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';

class UpdateCustomerUsecase {
  final CustomerRepository customerRepository;

  UpdateCustomerUsecase(this.customerRepository);

  Future<void> call(String id, String name, String email, String phone) async {
    final data = Customer(id, name, phone, email);
    return await this.customerRepository.updateCustomer(data);
  }
}
