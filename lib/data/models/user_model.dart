import 'package:learn_flutter/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String name,
    required String email,
    required String phone,
    String? avatar,
    required String token,
    required bool isAdmin,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
          token: token,
          isAdmin: isAdmin,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>;
    return UserModel(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      avatar: userData['avatar'],
      token: json['token'] ?? '',
      isAdmin: userData['is_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'is_admin': isAdmin,
      },
      'token': token,
    };
  }
}
