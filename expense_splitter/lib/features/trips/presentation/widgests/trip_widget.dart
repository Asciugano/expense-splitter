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
            title: Text(
              trip.name,
              style: Theme.of(context).textTheme.titleLarge,
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
            onTap: () {
              // TODO: trip detail
              print('detail');
            },
          ),
        ),
      ),
    );
  }
}
