import 'package:expense_splitter/core/entities/user.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromUser(User user, String password) {
    return LoginRequest(email: user.email, password: password);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromUser(User user, String password) {
    return RegisterRequest(
      name: user.name,
      email: user.email,
      password: password,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}
