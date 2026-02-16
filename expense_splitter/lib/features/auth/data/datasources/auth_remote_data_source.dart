import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/exception.dart';
import 'package:expense_splitter/core/network/api_client.dart';
import 'package:expense_splitter/core/token/token_storage.dart';

abstract interface class AuthRemoteDataSource {
  Future<User> register({
    required String email,
    required String name,
    required String password,
  });

  Future<User> login({required String email, required String password});

  Future<User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRemoteDataSourceImpl(this.apiClient, this.tokenStorage);

  @override
  Future<User> login({required String email, required String password}) async {
    final res = await apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });

    await tokenStorage.saveTokens(res['accessToken'], res['refreshToken']);

    return User.fromJson(res['user']);
  }

  @override
  Future<User> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final res = await apiClient.post('/auth/register', {
      'email': email,
      'name': name,
      'password': password,
    });

    await tokenStorage.saveTokens(res['accessToken'], res['refreshToken']);

    return User.fromJson(res['user']);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final res = await apiClient.get("/auth/me");
      return User.fromJson(res);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
