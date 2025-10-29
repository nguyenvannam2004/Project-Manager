import 'package:project_manager/feature/auth/domain/entities/User.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String username, String password) {
    return repository.login(username, password);
  }
}