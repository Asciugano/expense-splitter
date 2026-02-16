import 'package:expense_splitter/core/utils/show_snackbar.dart';
import 'package:expense_splitter/core/widgets/loader.dart';
import 'package:expense_splitter/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:expense_splitter/features/trips/presentation/widgests/trip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripPage extends StatefulWidget {
  static MaterialPageRoute<TripPage> route() =>
      MaterialPageRoute(builder: (context) => TripPage());
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TripsBloc, TripsState>(
        listener: (context, state) {
          if (state is TripsFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is TripsLoading) return Loader();
          if (state is TripsLoaded) {
            if (state.trips.isEmpty) {
              return const Center(child: Text("No trips yet. Add one!"));
            }

            return ListView.builder(
              itemCount: state.trips.length,
              itemBuilder: (context, idx) {
                final trip = state.trips[idx];

                return TripWidget(trip: trip);
              },
            );
          }
          // TODO: cambiare questo
          return const Center(child: Text("test"));
        },
      ),
    );
  }
}
