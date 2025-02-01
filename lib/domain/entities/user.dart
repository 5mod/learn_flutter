class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String token;
  final bool isAdmin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.token,
    required this.isAdmin,
  });
}
