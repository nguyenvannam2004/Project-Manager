import 'package:project_manager/feature/auth/data/datasource/AuthRemoteDataSource.dart';
import 'package:project_manager/feature/auth/domain/entities/User.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    return User(
      username: userModel.username,
      role: userModel.role,
      id: userModel.id,
    );
  }

  @override
  Future<void> register(String username, String password) async {
    await remoteDataSource.register(username, password);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await remoteDataSource.isLoggedIn();
  }
}
