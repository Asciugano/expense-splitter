import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/core/usecases/usecase.dart';
import 'package:expense_splitter/features/trips/domain/repositories/trips_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TripGetAll implements Usecase<List<Trip>, NoParams> {
  final TripsRepository repository;

  TripGetAll(this.repository);

  @override
  Future<Either<Failure, List<Trip>>> call(NoParams params) async {
    return await repository.getTrips();
  }
}

class NoParams {}
