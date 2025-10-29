import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';

class DeleteCustomerUsecase {
  final CustomerRepository customerRepository;

  DeleteCustomerUsecase(this.customerRepository);

  Future<void> call(int id) async {
    return await this.customerRepository.deleteCustomer(id);
  }
}
