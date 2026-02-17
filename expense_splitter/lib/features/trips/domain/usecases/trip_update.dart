import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/core/usecases/usecase.dart';
import 'package:expense_splitter/features/trips/domain/repositories/trips_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TripUpdate implements Usecase<Trip, UpdateTripParams> {
  final TripsRepository repository;

  TripUpdate(this.repository);

  @override
  Future<Either<Failure, Trip>> call(UpdateTripParams params) async {
    return await repository.updateTrip(params.trip, params.newTrip);
  }
}

class UpdateTripParams {
  final Trip trip;
  final Trip newTrip;

  UpdateTripParams({required this.trip, required this.newTrip});
}
