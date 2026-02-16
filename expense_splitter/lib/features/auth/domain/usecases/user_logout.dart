import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/core/usecases/usecase.dart';
import 'package:expense_splitter/features/auth/domain/repository/auth_repository.dart';
import 'package:expense_splitter/features/auth/domain/usecases/current_user.dart';
import 'package:fpdart/fpdart.dart';

class UserLogout implements Usecase<void, NoParams> {
  final AuthRepository authRepository;

  UserLogout(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}
