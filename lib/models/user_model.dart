// lib/models/user_model.dart
class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String role;

  UserModel({required this.id, required this.fullName, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'USER',
      );

  Map<String, dynamic> toJson() => {'id': id, 'fullName': fullName, 'email': email, 'role': role};
}
