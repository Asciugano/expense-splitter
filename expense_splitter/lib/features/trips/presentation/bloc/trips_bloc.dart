import 'package:equatable/equatable.dart';
import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/features/trips/domain/usecases/trip_create.dart';
import 'package:expense_splitter/features/trips/domain/usecases/trip_delete.dart';
import 'package:expense_splitter/features/trips/domain/usecases/trip_get_all.dart';
import 'package:expense_splitter/features/trips/domain/usecases/trip_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final TripGetAll _getAll;
  final TripCreate _create;
  final TripUpdate _update;
  final TripDelete _delete;

  TripsBloc({
    required TripGetAll getAll,
    required TripCreate create,
    required TripUpdate update,
    required TripDelete delete,
  }) : _getAll = getAll,
       _create = create,
       _update = update,
       _delete = delete,
       super(TripsLoading()) {
    on<GetTrips>(_onGetTrips);
    on<CreateTrip>(_onCreateTrip);
    on<DeleteTrip>(_onDeleteTrip);
    on<UpdateTrip>(_onUpdateTrip);
  }

  void _onGetTrips(GetTrips event, Emitter<TripsState> emit) async {
    emit(TripsLoading());
    final res = await _getAll.call(NoParams());

    res.fold((l) => emit(TripsFailure(l.message)), (r) => emit(TripsLoaded(r)));
  }

  void _onCreateTrip(CreateTrip event, Emitter<TripsState> emit) async {
    final res = await _create.call(
      CreateTripParams(name: event.name, partecipants: event.partecipants),
    );

    res.fold(
      (l) => emit(TripsFailure(l.message)),
      (r) => _emitSuccess(r, emit),
    );
  }

  void _onDeleteTrip(DeleteTrip event, Emitter<TripsState> emit) async {
    final res = await _delete.call(event.trip);

    res.fold(
      (l) => emit(TripsFailure(l.message)),
      (r) => _emitSuccess(null, emit),
    );
  }

  void _onUpdateTrip(UpdateTrip event, Emitter<TripsState> emit) async {
    final res = await _update.call(
      UpdateTripParams(trip: event.trip, newTrip: event.newTrip),
    );

    res.fold(
      (l) => emit(TripsFailure(l.message)),
      (r) => _emitSuccess(r, emit),
    );
  }

  void _emitSuccess(Trip? trip, Emitter<TripsState> emit) async {
    final currentTrips = List<Trip>.from((state as TripsLoaded).trips);
    if (trip != null) {
      currentTrips.add(trip);
    }

    emit(TripsLoaded(currentTrips));
  }
}
