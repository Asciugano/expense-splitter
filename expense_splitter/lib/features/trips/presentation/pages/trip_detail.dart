import 'package:expense_splitter/core/entities/trip.dart';
import 'package:flutter/material.dart';

class TripDetail extends StatelessWidget {
  static MaterialPageRoute<TripDetail> route({required Trip trip}) =>
      MaterialPageRoute(builder: (context) => TripDetail(trip: trip));

  final Trip trip;
  const TripDetail({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(trip.name)),
    );
  }
}
