class OrderModel {
  final String id;
  final DateTime createdAt;
  final String? description;
  final String? customerName;
  final bool finished;
  OrderModel({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.customerName,
    required this.finished,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      description: json['description'],
      customerName: json['customerName'],
      finished: json['finished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'customerName': customerName,
      'finished': finished,
    };
  }
}
