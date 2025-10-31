import 'dart:convert';

import 'package:project_manager/feature/auth/data/model/userdto.dart';
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

  Future<List<UserDto>> getUsers() async {
    final data = await apiClient.get('/api/Auth/users');

    final List<dynamic> decoded =
        data is String ? json.decode(data) as List<dynamic> : data as List<dynamic>;

    return decoded.map((e) => UserDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future updateUserRole(int userId, int role) async {
    // Gọi API update role
    final response = await apiClient.put(
      '/api/Auth/update-role/$userId', // endpoint update role
      {
        'roleId': role,
      },
    );
    // Nếu response trả về JSON, parse về UserDto
    final userDto = response is String
        ? UserDto.fromJson(json.decode(response) as Map<String, dynamic>)
        : UserDto.fromJson(response as Map<String, dynamic>);

    return userDto;
  }
}
