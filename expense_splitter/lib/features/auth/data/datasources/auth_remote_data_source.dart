import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/network/api_client.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> register({
    required String email,
    required String name,
    required String password,
  });

  Future<User> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<User> login({required String email, required String password}) async {
    final res = await apiClient.post('/api/auth/login', {
      'email': email,
      'password': password,
    });

    final token = res['token'];
    await apiClient.saveToken(token);

    return User.fromJson(res['user']);
  }

  @override
  Future<User> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final res = await apiClient.post('/api/auth/register', {
      'email': email,
      'name': name,
      'password': password,
    });

    final token = res['token'];
    await apiClient.saveToken(token);

    return User.fromJson(res['user']);
  }
}
