import 'package:project_manager/feature/customer/domain/entities/customer.dart';

class ApiClient {
  static List<Customer> customer = [];

  ApiClient() {
    if (customer.isNotEmpty) return;
    customer = [
      Customer('c1','kh1', '12321321','ksjdf@gmail.com'),
      Customer('c2', 'kh2', '12321321', 'ksjdf@gmail.com'),
      Customer( 'c3',  'kh3',  '12321321', 'ksjdf@gmail.com'),
    ];
  }


  Future<dynamic> get(String path) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/customers') {
      //call a server api --> get dataset
       return customer
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'phone': p.phone,
                'email': p.email,
              })
          .toList(); // product --> ProductModel
    }
    throw Exception('Unknown path: $path');
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async { 
 await Future.delayed(const Duration(milliseconds: 400));
    if (path == '/customers') {
      final newCustomer = Customer(
        body['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        body['name'],
        body['phone'],
        body['email'],
      );
      customer.add(newCustomer);
      return {
        'id': newCustomer.id,
        'name': newCustomer.name,
        'phone': newCustomer.phone,
        'email': newCustomer.email,
      };
    }
    throw Exception('Unknown POST path: $path');

   }

  Future<dynamic> put(String path, Map<String, dynamic> body) async { 
     await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/customers/')) {
      final id = path.split('/').last;
      final index = customer.indexWhere((p) => p.id == id);
      if (index == -1) throw Exception('Product not found');

      final updated = Customer(
        id,
        body['name'],
        body['phone'],
        body['email'],
      );
      customer[index] = updated;
      return {
        'id': updated.id,
        'name': updated.name,
        'phone': updated.phone,
        'email': updated.email,
      };
    }
    throw Exception('Unknown PUT path: $path');
  }

  Future<void> delete(String path) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (path.startsWith('/customers/')) {
      final id = path.split('/').last;
      customer.removeWhere((p) => p.id == id);
      return;
    }
    throw Exception('Unknown DELETE path: $path');
   }
}
