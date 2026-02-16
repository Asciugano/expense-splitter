import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/exception.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expense_splitter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    return await _getUser(
      () async =>
          await remoteDataSource.login(email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    return await _getUser(
      () async => await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) return left(Failure("User is not logged in"));

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final res = await remoteDataSource.logout();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
