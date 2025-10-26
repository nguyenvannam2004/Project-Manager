
import '../entities/customer.dart';

abstract class CustomerRepository {
  //crud  create, read, update, delete;
  Future<List<Customer>> getAllCustomer();
  Future<void> creatCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(String id);
}
