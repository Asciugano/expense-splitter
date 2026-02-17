part of 'trips_bloc.dart';

@immutable
sealed class TripsEvent extends Equatable {
  const TripsEvent();

  @override
  List<Object?> get props => [];
}

final class GetTrips extends TripsEvent {}

final class CreateTrip extends TripsEvent {
  final String name;
  final User owner;
  final List<User> partecipants;

  const CreateTrip({
    required this.partecipants,
    required this.name,
    required this.owner,
  });

  @override
  List<Object?> get props => [name];
}

final class DeleteTrip extends TripsEvent {
  final Trip trip;

  const DeleteTrip({required this.trip});

  @override
  List<Object?> get props => [trip];
}

final class UpdateTrip extends TripsEvent {
  final Trip trip;
  final Trip newTrip;

  const UpdateTrip({required this.trip, required this.newTrip});

  @override
  List<Object?> get props => [newTrip];
}
