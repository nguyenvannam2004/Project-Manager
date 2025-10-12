import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';

class GetCustomerUsecase {
  final CustomerRepository customerRepository;

  GetCustomerUsecase(this.customerRepository);
  Future<List<Customer>> call() async {
    return await customerRepository.getAllCustomer();
  }
}
