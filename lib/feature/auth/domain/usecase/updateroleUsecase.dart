import 'package:project_manager/feature/auth/domain/entities/User.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class UpdateRoleUseCase {
  final AuthRepository repository;

  UpdateRoleUseCase(this.repository);

  Future<User> call(int userId, int role) async {
    return await repository.updateUserRole(userId, role);
  }
}
