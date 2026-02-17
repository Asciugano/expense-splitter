import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TripsRepository {
  Future<Either<Failure, List<Trip>>> getTrips();
  Future<Either<Failure, Trip>> createTrip({
    required String name,
    List<User>? partecipants,
  });
  Future<Either<Failure, Trip>> updateTrip(Trip trip, Trip newTrip);
  Future<Either<Failure, void>> deleteTrip(Trip trip);
}
