import 'package:flutter/material.dart';
import 'main_layout.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Convertidor de Divisas'),
          centerTitle: true,
          leading: const Icon(Icons.calculate_outlined),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conversión',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text('Cantidad'),
                      const SizedBox(height: 8),
                      TextField(
                        // controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('De'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: 'USD',
                        items: const [
                          DropdownMenuItem(
                            value: 'USD',
                            child: Text('\$ USD - Dólar Estadounidense'),
                          ),
                          DropdownMenuItem(
                            value: 'EUR',
                            child: Text('€ EUR - Euro'),
                          ),
                          DropdownMenuItem(
                            value: 'DOP',
                            child: Text('RD\$ DOP - Peso Dominicano'),
                          ),
                        ],
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.swap_vert, size: 28),
                          onPressed: () {}, // Intercambio de monedas
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('A'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: 'DOP',
                        items: const [
                          DropdownMenuItem(
                            value: 'USD',
                            child: Text('\$ USD - Dólar Estadounidense'),
                          ),
                          DropdownMenuItem(
                            value: 'EUR',
                            child: Text('€ EUR - Euro'),
                          ),
                          DropdownMenuItem(
                            value: 'DOP',
                            child: Text('RD\$ DOP - Peso Dominicano'),
                          ),
                        ],
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Convertir',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Card: Tasas Actuales
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tasas Actuales',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('1 USD'), Text('RD\$ 59.2')],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('1 EUR'), Text('RD\$ 63.95')],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tasas del Banco Popular • Actualizadas cada hora',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
