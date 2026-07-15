import '../../domain/entites/user_entity.dart';
class UserModel extends UserEntity {
  final int id;

  UserModel({
    required this.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? data;

    return UserModel(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      token: data['token'] ?? '',
    );
  }
}
