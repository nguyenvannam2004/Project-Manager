import 'package:project_manager/feature/customer/data/datasource/remotedatasource.dart';
import 'package:project_manager/feature/customer/data/models/CustomerModel.dart';
import 'package:project_manager/feature/customer/domain/entities/customer.dart';
import 'package:project_manager/feature/customer/domain/repository/customerrepository.dart';

class CustomerRepositoryIpl extends CustomerRepository {
  final RemoteDataSource remotedatasrc;

  CustomerRepositoryIpl(this.remotedatasrc);
  @override
  Future<void> creatCustomer(Customer customer) {
    final data = CustomerModel(customer.id, customer.name, customer.phone, customer.email);
    return this.remotedatasrc.createCustomer(data);
  }

  @override
  Future<void> deleteCustomer(int id) {
    return this.remotedatasrc.deleteCustomer(id);
  }

  @override
  Future<List<Customer>> getAllCustomer() {
    return this.remotedatasrc.getAllCustomer();
  }

  @override
  Future<void> updateCustomer(Customer customer) {
    final data = CustomerModel(customer.id, customer.name, customer.phone, customer.email);
    return this.remotedatasrc.updateCustomer(data);
  }
}
