import 'package:project_manager/feature/auth/domain/entities/User.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class GetUserUsecase
{
  final AuthRepository repository;

  GetUserUsecase(this.repository);
  Future<List<User>> call() async {
    return await repository.getAllUsers();
  }

}