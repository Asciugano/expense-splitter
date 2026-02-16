class User {
  final String id;
  final String email;
  final String name;
  final String refreshToken;
  final List<String> trips;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.refreshToken,
    required this.trips,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      refreshToken: json['refreshToken'],
      trips: List<String>.from(json['trips'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'refreshToken': refreshToken,
      'trips': trips,
    };
  }

  User copyWith({List<String>? trips}) {
    return User(
      id: id,
      name: name,
      email: email,
      refreshToken: refreshToken,
      trips: trips ?? this.trips,
    );
  }
}
