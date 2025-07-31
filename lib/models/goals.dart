class Goal {
  final String userId;
  final String title;
  final double target;
  final double current;
  final String? deadline;

  Goal({
    required this.userId,
    required this.title,
    required this.target,
    required this.current,
    this.deadline,
  });

  factory Goal.fromMap(Map<String, dynamic> map) {
    if (map['user_id'] == null || map['title'] == null) {
      throw Exception('Invalid goal data: missing required fields');
    }

    return Goal(
      userId: map['user_id'],
      title: map['title'],
      target: (map['target'] ?? 0).toDouble(),
      current: (map['current'] ?? 0).toDouble(),
      deadline: map['deadline'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'target': target,
      'current': current,
      'deadline': deadline,
    };
  }

  Goal copyWith({
    String? userId,
    String? title,
    double? target,
    double? current,
    String? deadline,
  }) {
    return Goal(
      userId: userId ?? this.userId,
      title: title ?? this.title,
      target: target ?? this.target,
      current: current ?? this.current,
      deadline: deadline ?? this.deadline,
    );
  }
}
