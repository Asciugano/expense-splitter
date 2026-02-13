import 'package:expense_splitter/core/exception/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}
