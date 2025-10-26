import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';

class CreatecustomerUsecase {
  final CustomerRepository customerRepository;

  CreatecustomerUsecase(this.customerRepository);
  // Use parameter order (id, name, phone, email)
  Future<void> call(String id, String name, String phone, String email) async {
    final data = Customer(id, name, phone, email);
    return await this.customerRepository.creatCustomer(data);
  }
}
