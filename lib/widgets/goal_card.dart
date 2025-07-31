import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavingsGoalCard extends StatefulWidget {
  final String title;
  final double currentAmount;
  final double goalAmount;
  final Function(double amount)? onAddAmount;
  final VoidCallback? onDelete;

  const SavingsGoalCard({
    super.key,
    required this.title,
    required this.currentAmount,
    required this.goalAmount,
    this.onAddAmount,
    this.onDelete,
  });

  @override
  State<SavingsGoalCard> createState() => _SavingsGoalCardState();
}

class _SavingsGoalCardState extends State<SavingsGoalCard> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final progress = (widget.currentAmount / widget.goalAmount).clamp(0.0, 1.0);
    final formatter = NumberFormat.currency(locale: 'es_DO', symbol: 'RD\$');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y eliminar
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          Text(
            '${formatter.format(widget.currentAmount)} de ${formatter.format(widget.goalAmount)}',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Progreso'),
              const Spacer(),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            color: Colors.black,
            backgroundColor: Colors.grey[300],
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          if (progress >= 1.0)
            const Text(
              '🎉 ¡Felicidades! Has alcanzado tu meta',
              style: TextStyle(color: Colors.green),
            ),
          if (progress < 1.0)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Agregar monto',
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(_amountController.text);
                    if (amount != null && amount > 0) {
                      widget.onAddAmount?.call(amount);
                      _amountController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Agregar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
