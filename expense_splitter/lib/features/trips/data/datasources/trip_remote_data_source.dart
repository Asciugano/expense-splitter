import 'package:expense_splitter/core/entities/trip.dart';
import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/core/network/api_client.dart';

abstract interface class TripRemoteDataSource {
  Future<List<Trip>> getTrips();
  Future<Trip> createTrip({
    required String name,
    required User owner,
    List<User>? partecipants,
  });
  Future<Trip> updateTrip(Trip tirp, Trip newTrip);
  Future<void> deleteTrip(Trip tirp);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final ApiClient apiClient;

  TripRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Trip> createTrip({
    required String name,
    required User owner,
    List<User>? partecipants,
  }) async {
    final res = await apiClient.post('/trip', {
      'name': name,
      'partecipants': partecipants?.map((user) => user.id).toList(),
    });

    return Trip.fromJson(res);
  }

  @override
  Future<void> deleteTrip(Trip tirp) async {
    return await apiClient.delete('/trip/${tirp.id}');
  }

  @override
  Future<List<Trip>> getTrips() async {
    final res = await apiClient.get('/trip');
    final tripsJson = res['trips'];
    return (tripsJson as List)
        .map((tripJson) => Trip.fromJson(tripJson))
        .toList();
  }

  @override
  Future<Trip> updateTrip(Trip tirp, Trip newTrip) async {
    final res = await apiClient.put('/trip/${tirp.id}', newTrip.toJson());

    return Trip.fromJson(res);
  }
}
