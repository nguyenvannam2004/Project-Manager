import 'package:project_manager/core/network/customer/apiclient.dart';
import 'package:project_manager/feature/customer/data/models/CustomerModel.dart';

class RemoteDataSource {
  final ApiClient apiclient;
  RemoteDataSource(this.apiclient);

  Future<List<CustomerModel>> getAllCustomer() async {
  final data = await apiclient.get('/customers') as List<dynamic>;
  return data
      .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>, e['id'] as String))
      .toList();
  }


  Future<CustomerModel> createCustomer(CustomerModel customer) async {
    final data = await apiclient.post('/customers', customer.toJson());
    return CustomerModel.fromJson(data as Map<String, dynamic>, data['id'] as String);
  }

  Future<CustomerModel> updateCustomer(CustomerModel customer) async {
    final data = await apiclient.put('/customers/${customer.id}', customer.toJson());
    return CustomerModel.fromJson(data as Map<String, dynamic>, customer.id);
  }

  Future<void> deleteCustomer(String id) {
    return this.apiclient.delete('/customers/$id');
  }
}
