import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call(String username, String password) {
    return repository.register(username, password);
  }
}
