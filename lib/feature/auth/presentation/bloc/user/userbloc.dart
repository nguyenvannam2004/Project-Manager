import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/auth/domain/repository/AuthRepository.dart';
import 'package:project_manager/feature/auth/domain/usecase/getuserusecase.dart';
import 'package:project_manager/feature/auth/domain/usecase/updateroleUsecase.dart';
import 'package:project_manager/feature/auth/presentation/bloc/user/useevent.dart';
import 'package:project_manager/feature/auth/presentation/bloc/user/userstate.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUsecase getUserUsecase;
  final UpdateRoleUseCase updateRoleUseCase;

  UserBloc(this.getUserUsecase, this.updateRoleUseCase) : super(UserInitial()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await this.getUserUsecase.call();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUserRoleEvent>((event, emit) async {
      emit(UserLoading());
      
      try {
        final roleMap = {
          'ADMIN': 1,
          'LEADER': 2,
          'STAFF': 3,
        };
        final roleInt = roleMap[event.newRole] ?? 3; // default là STAFF
        final updatedUser = await this.updateRoleUseCase.call(
          event.userId,
          roleInt,
        );
        // reload users sau khi update
        final users = await this.getUserUsecase.call();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
