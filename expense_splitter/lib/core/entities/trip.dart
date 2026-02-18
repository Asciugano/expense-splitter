class Trip {
  final String id;
  final String name;
  final String owner;
  final DateTime createdAt;
  final List<String> partecipants;
  final List<String> expenses;

  Trip({
    required this.name,
    required this.id,
    required this.owner,
    required this.partecipants,
    required this.createdAt,
    required this.expenses,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
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
      'createdAt': createdAt.toIso8601String(),
      'expenses': expenses,
    };
  }

  Trip copyWith({List<String>? partecipants, List<String>? expenses}) {
    return Trip(
      name: name,
      id: id,
      owner: owner,
      createdAt: createdAt,
      partecipants: partecipants ?? this.partecipants,
      expenses: expenses ?? this.expenses,
    );
  }
}
