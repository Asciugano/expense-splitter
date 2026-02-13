class Trip {
  final String id;
  final String name;
  final String owner;
  final List<String> partecipants;
  final List<String> expenses;

  Trip({
    required this.name,
    required this.id,
    required this.owner,
    required this.partecipants,
    required this.expenses,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      partecipants: List<String>.from(json['partecipants'] ?? []),
      expenses: List<String>.from(json['expenses'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'owner': owner,
      'partecipants': partecipants,
      'expenses': expenses,
    };
  }

  Trip copyWith({List<String>? partecipants, List<String>? expenses}) {
    return Trip(
      name: name,
      id: id,
      owner: owner,
      partecipants: partecipants ?? this.partecipants,
      expenses: expenses ?? this.expenses,
    );
  }
}
