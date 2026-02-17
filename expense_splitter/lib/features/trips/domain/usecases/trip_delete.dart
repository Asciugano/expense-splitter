import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/core/usecases/usecase.dart';
import 'package:expense_splitter/features/trips/domain/repositories/trips_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TripDelete implements Usecase<void, Trip> {
  final TripsRepository repository;

  TripDelete(this.repository);

  @override
  Future<Either<Failure, void>> call(Trip params) async {
    return await repository.deleteTrip(params);
  }
}
