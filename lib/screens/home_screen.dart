import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("EEEE, d 'de' MMMM 'de' y", 'es_ES').format(now);
  }

  Widget _buildExchangeCard(
    String currency,
    String buy,
    String sell,
    String change,
    Color iconColor,
    Color chipColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 236, 240),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Text(currency[0], style: TextStyle(color: iconColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$currency/DOP',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Compra: RD\$$buy\nVenta: RD\$$sell',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.trendingDown, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            backgroundColor: chipColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestTile(String title, String rate, Color bgColor) {
    return ListTile(
      title: Text(title),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          rate,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    '¡Hola, Luis! 👋',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    getFormattedDate(),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 24),

                // Tasas de cambio
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💳 Tasas de Cambio - Banco Popular',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _buildExchangeCard(
                        'USD',
                        '58.50',
                        '59.20',
                        '0.15%',
                        Colors.green,
                        Colors.black,
                      ),
                      _buildExchangeCard(
                        'EUR',
                        '62.80',
                        '63.95',
                        '0.25%',
                        Colors.blue,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Tasas de interés
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tasas de Interés',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _buildInterestTile('Ahorros', '3.5% anual', Colors.grey),
                      _buildInterestTile(
                        'Certificado 12 meses',
                        '7.2% anual',
                        Colors.black,
                      ),
                      _buildInterestTile(
                        'Préstamos personales',
                        '12.5% anual',
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Accesos rápidos
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEAEAEA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Accesos Rápidos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Convertir\nDivisas',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF3F3F3),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Mis\nMetas',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
