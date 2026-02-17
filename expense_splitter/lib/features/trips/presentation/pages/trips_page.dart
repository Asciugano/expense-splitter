import 'package:expense_splitter/core/utils/show_snackbar.dart';
import 'package:expense_splitter/core/widgets/loader.dart';
import 'package:expense_splitter/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:expense_splitter/features/trips/presentation/widgests/trip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsPage extends StatefulWidget {
  static MaterialPageRoute<TripsPage> route() =>
      MaterialPageRoute(builder: (context) => TripsPage());
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  void initState() {
    super.initState();

    context.read<TripsBloc>().add(GetTrips());
  }

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

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TripsBloc>().add(GetTrips());
                await context.read<TripsBloc>().stream.firstWhere(
                  (s) => s is! TripsLoading,
                );
              },
              child: ListView.builder(
                itemCount: state.trips.length,
                itemBuilder: (context, idx) {
                  final trip = state.trips[idx];

                  return TripWidget(trip: trip);
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTripSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateTripSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create a Trip',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Trip Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter a Name' : null,
                  ),

                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<TripsBloc>().add(
                            CreateTrip(name: nameController.text.trim()),
                          );

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
