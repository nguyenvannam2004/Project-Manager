
import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomer();
  Future<void> creatCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
}
