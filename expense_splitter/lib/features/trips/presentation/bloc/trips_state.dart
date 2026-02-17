part of 'trips_bloc.dart';

@immutable
class TripsState extends Equatable {
  const TripsState();

  @override
  List<Object?> get props => [];
}

final class TripsInitial extends TripsState {}

final class TripsLoading extends TripsState {}

final class TripsLoaded extends TripsState {
  final List<Trip> trips;

  const TripsLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}

final class TripsFailure extends TripsState {
  final String message;

  const TripsFailure([this.message = "Ops... Somethig went wrong"]);

  @override
  List<Object?> get props => [message];
}

final class TripSuccess extends TripsState {
  final List<Trip> trip;

  const TripSuccess(this.trip);
}

class TripOperationSuccess extends TripsState {}
