import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> register({
    required String email,
    required String name,
    required String password,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
}
