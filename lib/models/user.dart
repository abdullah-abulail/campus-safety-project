class User {
  final String email;
  final String name;
  final String role;
  final String? department;

  User({
    required this.email,
    required this.name,
    required this.role,
    this.department,
  });
}
