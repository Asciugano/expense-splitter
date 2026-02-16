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
  final String owner;
  final List<String> partecipants;

  const CreateTrip({
    required this.partecipants,
    required this.name,
    required this.owner,
  });

  @override
  List<Object?> get props => [name];
}

final class DeleteTrip extends TripsEvent {
  final String tripID;

  const DeleteTrip({required this.tripID});

  @override
  List<Object?> get props => [tripID];
}

final class UpdateTrip extends TripsEvent {
  final String tripID;
  final String name;
  final List<String>? partecipants;
  final List<String>? expenses;

  const UpdateTrip({
    required this.tripID,
    required this.name,
    this.partecipants,
    this.expenses,
  });

  @override
  List<Object?> get props => [tripID, name];
}
