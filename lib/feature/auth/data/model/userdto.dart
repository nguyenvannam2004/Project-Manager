// lib/feature/auth/data/model/usermodel.dart
import 'package:project_manager/feature/auth/domain/entities/User.dart';

class UserDto extends User{
  UserDto({required super.id, required super.username, required super.role});
  

  // Chuyển từ JSON sang Model
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['Id'] ?? json['id'] ?? 0,
      username: json['Username'] ?? json['username'] ?? '',
      role: json['Role'] ?? json['role'] ?? '',
    );
  }

  /// Chuyển từ Model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
    };
  }
}
