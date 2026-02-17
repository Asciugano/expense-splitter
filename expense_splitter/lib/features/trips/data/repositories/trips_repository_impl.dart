import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/exception.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/features/trips/data/datasources/trip_remote_data_source.dart';
import 'package:expense_splitter/features/trips/domain/repositories/trips_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripRemoteDataSource tripRemoteDataSource;

  TripsRepositoryImpl(this.tripRemoteDataSource);

  @override
  Future<Either<Failure, Trip>> createTrip({
    required String name,
    List<User>? partecipants,
  }) async {
    try {
      final trip = await tripRemoteDataSource.createTrip(
        name: name,
        partecipants: partecipants,
      );

      return right(trip);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrip(Trip tirp) async {
    try {
      await tripRemoteDataSource.deleteTrip(tirp);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Trip>>> getTrips() async {
    try {
      final trips = await tripRemoteDataSource.getTrips();
      return right(trips);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Trip>> updateTrip(Trip tirp, Trip newTrip) async {
    try {
      final trip = await tripRemoteDataSource.updateTrip(tirp, newTrip);

      return right(trip);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
