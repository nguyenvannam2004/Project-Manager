// lib/feature/auth/data/model/usermodel.dart
class UserModel {
  final int id;
  final String username;
  final String role;
  final String token; 

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['Id'] ?? json['id'] ?? 0, // accept either Id or id
    username: json['Username'] ?? json['username'] ?? '',
    role: json['Role'] ?? json['role'] ?? '', // accept either Role or role
    token: (json['token'] ?? json['Token'] ?? '').toString().trim(),
  );
}
