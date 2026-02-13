class Expense {
  final String id;
  final double amount;
  final String title;
  final String tripId;

  Expense({
    required this.id,
    required this.amount,
    required this.title,
    required this.tripId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      amount: json['amount'] ?? '',
      tripId: json['tripId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'amount': amount, 'title': title, 'tripId': tripId};
  }
}
