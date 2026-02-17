import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/exception/failure.dart';
import 'package:expense_splitter/core/usecases/usecase.dart';
import 'package:expense_splitter/features/trips/domain/repositories/trips_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TripCreate implements Usecase<Trip, CreateTripParams> {
  final TripsRepository repository;

  TripCreate(this.repository);

  @override
  Future<Either<Failure, Trip>> call(CreateTripParams params) async {
    return await repository.createTrip(
      name: params.name,
      owner: params.owner,
      partecipants: params.partecipants,
    );
  }
}

class CreateTripParams {
  final String name;
  final User owner;
  final List<User>? partecipants;

  CreateTripParams({
    required this.name,
    required this.partecipants,
    required this.owner,
  });
}
