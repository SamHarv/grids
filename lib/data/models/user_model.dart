class UserModel {
  /// [UserModel] model, not names "User" to avoid conflict with Firebase User
  final String id;
  final String email;
  final String name;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
  });
}
