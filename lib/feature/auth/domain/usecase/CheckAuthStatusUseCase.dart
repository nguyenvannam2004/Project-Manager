import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<bool> call() => repository.isLoggedIn();
}
