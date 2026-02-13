import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/core/usecases/usecase.dart';
import 'package:expense_splitter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserRegister implements Usecase<User, UserRegisterParams> {
  final AuthRepository authRepository;

  UserRegister(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserRegisterParams params) async {
    return await authRepository.register(
      email: params.email,
      name: params.name,
      password: params.password,
    );
  }
}

class UserRegisterParams {
  final String email;
  final String name;
  final String password;

  UserRegisterParams({
    required this.email,
    required this.name,
    required this.password,
  });
}
