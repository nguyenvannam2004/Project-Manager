import 'package:project_manager/feature/auth/data/model/usermodel.dart';

import '../../../../core/network/auth/IApiclient.dart';

class AuthRemoteDataSource {
  final IApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<UserModel> login(String username, String password) async {
    final response = await apiClient.post('/api/Auth/login', {
      'username': username,
      'password': password,
    });
    print('Login response: $response'); // Debug print
    final user = UserModel.fromJson(response);
    print('Token from response: ${user.token}'); // Debug token
    // Only save non-empty tokens
    if (user.token.isNotEmpty) {
      await apiClient.setToken(user.token); // Lưu token ngay sau login
      print('Token saved successfully'); // Confirm token save
    } else {
      print('Warning: token is empty; not saving token');
    }
    return user;
  }

  Future<void> register(String username, String password) async {
    await apiClient.post('/api/Auth/register', {
      'username': username,
      'password': password,
    });
  }

  Future<void> logout() async {
    await apiClient.clearToken(); // Xóa token khi logout
  }

  Future<bool> isLoggedIn() async {
    return await apiClient.isLoggedIn();
  }
}
