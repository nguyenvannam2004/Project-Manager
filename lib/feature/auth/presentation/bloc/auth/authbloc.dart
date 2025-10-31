import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/domain/usecase/LoginUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/LogoutUsecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/RegisterUsecase.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/auth/authstate.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await loginUseCase.call(event.username, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await registerUseCase.call(event.username, event.password);
      emit(const AuthUnauthenticated()); // redirect login
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase.call();
    emit(const AuthUnauthenticated());
  }
}
