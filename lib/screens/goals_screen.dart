import 'package:finance_project/models/goals.dart';
import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:finance_project/widgets/goal_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('goals');
    final currentUser = prefs.getString('current_user');

    if (saved != null && currentUser != null) {
      final List decoded = json.decode(saved);
      final userGoals =
          decoded
              .where((map) => map['user_id'] != null)
              .map((map) => Goal.fromMap(map))
              .where((g) => g.userId == currentUser)
              .toList();

      setState(() {
        _goals = userGoals;
      });
    }
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('goals');
    final currentUser = prefs.getString('current_user');

    if (currentUser == null) return;

    List<Map<String, dynamic>> allGoals = [];

    if (saved != null) {
      final decoded = List<Map<String, dynamic>>.from(json.decode(saved));
      allGoals = decoded.where((g) => g['user_id'] != currentUser).toList();
    }

    final currentUserGoals = _goals.map((g) => g.toMap()).toList();
    allGoals.addAll(currentUserGoals);

    await prefs.setString('goals', json.encode(allGoals));
  }

  Future<void> _addGoal({
    required String title,
    required double target,
    required double current,
    String? deadline,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = prefs.getString('current_user');
    if (currentUser == null) return;

    setState(() {
      _goals.add(
        Goal(
          userId: currentUser,
          title: title,
          target: target,
          current: current,
          deadline: deadline,
        ),
      );
    });
    await _saveGoals();
  }

  void _deleteGoal(int index) {
    setState(() {
      _goals.removeAt(index);
    });
    _saveGoals();
  }

  void _updateGoalAmount(int index, double amountToAdd) {
    setState(() {
      final goal = _goals[index];
      _goals[index] = goal.copyWith(current: goal.current + amountToAdd);
    });
    _saveGoals();
  }

  void _showNewGoalModal(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final currentController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Center(
            child: Text(
              "Nueva Meta",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de la meta",
                    hintText: "Ej. Viaje a Nueva York",
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Monto objetivo",
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: currentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Monto actual"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Fecha límite (opcional)",
                    hintText: "dd/mm/aaaa",
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dateController.text =
                          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  final name = nameController.text.trim();
                  final target = double.tryParse(targetController.text) ?? 0;
                  final current = double.tryParse(currentController.text) ?? 0;
                  final deadline = dateController.text.trim();

                  if (name.isNotEmpty && target > 0) {
                    _addGoal(
                      title: name,
                      target: target,
                      current: current,
                      deadline: deadline.isEmpty ? null : deadline,
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text(
                  "Crear Meta",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Metas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showNewGoalModal(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              _goals.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.savings_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "No tienes metas aún",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Crea tu primera meta financiera para comenzar a ahorrar",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Crear primera meta",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _showNewGoalModal(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      return SavingsGoalCard(
                        title: goal.title,
                        currentAmount: goal.current,
                        goalAmount: goal.target,
                        onAddAmount:
                            (amount) => _updateGoalAmount(index, amount),
                        onDelete: () => _deleteGoal(index),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
