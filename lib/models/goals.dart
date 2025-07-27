import 'package:flutter/material.dart';

enum GoalStatus { active, completed, paused, cancelled }

enum GoalCategory {
  savings,
  investment,
  debt,
  emergency,
  travel,
  home,
  car,
  education,
  retirement,
  other,
}

class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdDate;
  final DateTime targetDate;
  final GoalStatus status;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.createdDate,
    required this.targetDate,
    this.status = GoalStatus.active,
  });

  // Calculate progress percentage
  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  // Calculate remaining amount
  double get remainingAmount {
    return (targetAmount - currentAmount).clamp(0.0, targetAmount);
  }

  // Calculate days remaining
  int get daysRemaining {
    return targetDate.difference(DateTime.now()).inDays;
  }

  // Check if goal is completed
  bool get isCompleted => currentAmount >= targetAmount;

  // Check if goal is overdue
  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isCompleted;

  // Calculate suggested monthly contribution
  double get suggestedMonthlyContribution {
    if (isCompleted || daysRemaining <= 0) return 0.0;
    int monthsRemaining = (daysRemaining / 30).ceil();
    if (monthsRemaining <= 0) return remainingAmount;
    return remainingAmount / monthsRemaining;
  }

  // Create a copy with updated values
  Goal copyWith({
    String? id,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? createdDate,
    DateTime? targetDate,
    GoalStatus? status,
    GoalCategory? category,
    Color? color,
    IconData? icon,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      createdDate: createdDate ?? this.createdDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdDate': createdDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'status': status.name,
    };
  }

  // Create from JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      targetAmount: json['targetAmount'].toDouble(),
      currentAmount: json['currentAmount']?.toDouble() ?? 0.0,
      createdDate: DateTime.parse(json['createdDate']),
      targetDate: DateTime.parse(json['targetDate']),
      status: GoalStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => GoalStatus.active,
      ),
    );
  }
}

// Goal Category Extensions
extension GoalCategoryExtension on GoalCategory {
  String get displayName {
    switch (this) {
      case GoalCategory.savings:
        return 'Ahorro';
      case GoalCategory.investment:
        return 'Inversión';
      case GoalCategory.debt:
        return 'Deuda';
      case GoalCategory.emergency:
        return 'Emergencia';
      case GoalCategory.travel:
        return 'Viaje';
      case GoalCategory.home:
        return 'Casa';
      case GoalCategory.car:
        return 'Carro';
      case GoalCategory.education:
        return 'Educación';
      case GoalCategory.retirement:
        return 'Retiro';
      case GoalCategory.other:
        return 'Otro';
    }
  }

  IconData get defaultIcon {
    switch (this) {
      case GoalCategory.savings:
        return Icons.savings;
      case GoalCategory.investment:
        return Icons.trending_up;
      case GoalCategory.debt:
        return Icons.money_off;
      case GoalCategory.emergency:
        return Icons.emergency;
      case GoalCategory.travel:
        return Icons.flight;
      case GoalCategory.home:
        return Icons.home;
      case GoalCategory.car:
        return Icons.directions_car;
      case GoalCategory.education:
        return Icons.school;
      case GoalCategory.retirement:
        return Icons.elderly;
      case GoalCategory.other:
        return Icons.star;
    }
  }

  Color get defaultColor {
    switch (this) {
      case GoalCategory.savings:
        return Colors.green;
      case GoalCategory.investment:
        return Colors.blue;
      case GoalCategory.debt:
        return Colors.red;
      case GoalCategory.emergency:
        return Colors.orange;
      case GoalCategory.travel:
        return Colors.purple;
      case GoalCategory.home:
        return Colors.brown;
      case GoalCategory.car:
        return Colors.grey;
      case GoalCategory.education:
        return Colors.indigo;
      case GoalCategory.retirement:
        return Colors.teal;
      case GoalCategory.other:
        return Colors.blueGrey;
    }
  }
}

// Goal Status Extensions
extension GoalStatusExtension on GoalStatus {
  String get displayName {
    switch (this) {
      case GoalStatus.active:
        return 'Activa';
      case GoalStatus.completed:
        return 'Completada';
      case GoalStatus.paused:
        return 'Pausada';
      case GoalStatus.cancelled:
        return 'Cancelada';
    }
  }

  Color get color {
    switch (this) {
      case GoalStatus.active:
        return Colors.blue;
      case GoalStatus.completed:
        return Colors.green;
      case GoalStatus.paused:
        return Colors.orange;
      case GoalStatus.cancelled:
        return Colors.red;
    }
  }
}

// Transaction for goal contributions
class GoalTransaction {
  final String id;
  final String goalId;
  final double amount;
  final DateTime date;
  final String? note;
  final bool isContribution; // true for contribution, false for withdrawal

  GoalTransaction({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    this.note,
    this.isContribution = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalId': goalId,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'isContribution': isContribution,
    };
  }

  factory GoalTransaction.fromJson(Map<String, dynamic> json) {
    return GoalTransaction(
      id: json['id'],
      goalId: json['goalId'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      note: json['note'],
      isContribution: json['isContribution'] ?? true,
    );
  }
}
