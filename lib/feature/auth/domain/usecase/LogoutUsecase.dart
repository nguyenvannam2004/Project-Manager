import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}
