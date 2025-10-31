import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Load tất cả user
class LoadUsersEvent extends UserEvent {}

// Cập nhật role
class UpdateUserRoleEvent extends UserEvent {
  final int userId;
  final String newRole;

  UpdateUserRoleEvent({required this.userId, required this.newRole});

  @override
  List<Object?> get props => [userId, newRole];
}
