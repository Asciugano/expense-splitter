import 'package:equatable/equatable.dart';
import 'package:expense_splitter/core/entities/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc() : super(TripsInitial()) {
    on<TripsEvent>((_, emit) => emit(TripsLoading()));
    on<GetTrips>(_onGetTrips);
    on<CreateTrip>(_onCreateTrip);
    on<DeleteTrip>(_onDeleteTrip);
    on<UpdateTrip>(_onUpdateTrip);
  }

  void _onGetTrips(GetTrips event, Emitter<TripsState> emit) async {}
  void _onCreateTrip(CreateTrip event, Emitter<TripsState> emit) async {}
  void _onDeleteTrip(DeleteTrip event, Emitter<TripsState> emit) async {}
  void _onUpdateTrip(UpdateTrip event, Emitter<TripsState> emit) async {}
}
