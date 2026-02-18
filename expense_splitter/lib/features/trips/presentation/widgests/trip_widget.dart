import 'package:expense_splitter/features/trips/presentation/pages/trip_detail.dart';
import 'package:flutter/material.dart';
import 'package:expense_splitter/core/entities/trip.dart';

class TripWidget extends StatelessWidget {
  final Trip trip;
  const TripWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // TODO: Delete/Update
        print('Delete/Update');
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
              ],
            ),
            subtitle: Text('${trip.partecipants.length} participants'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: aggiungere spesa (anche backend)
                // NOTE: aggiungere tabella con tripID e userID + amount(quanto deve ancora pagare (riutilizzare /pay per pagare questa))
                // NOTE: e roimuovere poi da expense quando e' finito l'amount
                Text(
                  '\$0.00',
                  style: TextStyle(
                    // TODO: controllare se si devono dei soldi Red se no Green
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () => Navigator.push(context, TripDetail.route(trip: trip)),
          ),
        ),
      ),
    );
  }
}
