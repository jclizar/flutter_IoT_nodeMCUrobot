class User {
  final String email;
  final String password;
  final String name;

  User({
    required this.name,
    required this.email,
    required this.password,
  });

  User copyWith(
      {required String name, required String email, required String password}) {
    return User(
      name: name,
      email: email,
      password: password,
    );
  }
}
