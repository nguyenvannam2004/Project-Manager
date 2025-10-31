import 'package:project_manager/feature/auth/domain/entities/User.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<void> register(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();

  Future<List<User>> getAllUsers();
  Future<User> updateUserRole(int userId, int role);
}
