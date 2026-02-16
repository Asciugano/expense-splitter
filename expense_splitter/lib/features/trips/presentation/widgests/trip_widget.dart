import 'package:flutter/widgets.dart';
import 'package:expense_splitter/core/entities/trip.dart';

class TripWidget extends StatelessWidget {
  final Trip trip;
  const TripWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(trip.name));
  }
}
