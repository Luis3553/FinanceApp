import 'package:finance_project/models/currency.dart';
import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:finance_project/services/auth_service.dart';
import 'package:finance_project/services/currency_service.dart';
import 'package:finance_project/utils/currency_converter.dart';
import 'package:lucide_icons/lucide_icons.dart';

final authService = AuthService();
final currencyService = CurrencyService();

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  late Future<CurrencyResponse> futureCurrencies;
  String fromCurrency = 'USD';
  String toCurrency = 'DOP';
  final TextEditingController amountController = TextEditingController();
  double? result;

  @override
  void initState() {
    super.initState();
    futureCurrencies = authService.fetchAccessToken().then(
      (token) => currencyService.fetchCurrencies(token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: FutureBuilder<CurrencyResponse>(
        future: futureCurrencies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.white,
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
              backgroundColor: Colors.white,
            );
          }

          final rates = snapshot.data!.monedas;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Convertidor de Divisas'),
              centerTitle: true,
              leading: const Icon(
                LucideIcons.calculator,
                color: Colors.black,
                size: 20,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Conversión Card
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 209, 209, 209),
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Conversión',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '0.00',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: fromCurrency,
                            items: const [
                              DropdownMenuItem(
                                value: 'USD',
                                child: Text('USD - Dólar'),
                              ),
                              DropdownMenuItem(
                                value: 'EUR',
                                child: Text('EUR - Euro'),
                              ),
                              DropdownMenuItem(
                                value: 'DOP',
                                child: Text('DOP - Peso Dominicano'),
                              ),
                            ],
                            onChanged: (v) => setState(() => fromCurrency = v!),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: toCurrency,
                            items: const [
                              DropdownMenuItem(
                                value: 'USD',
                                child: Text('USD - Dólar'),
                              ),
                              DropdownMenuItem(
                                value: 'EUR',
                                child: Text('EUR - Euro'),
                              ),
                              DropdownMenuItem(
                                value: 'DOP',
                                child: Text('DOP - Peso Dominicano'),
                              ),
                            ],
                            onChanged: (v) => setState(() => toCurrency = v!),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                final amount =
                                    double.tryParse(amountController.text) ?? 0;
                                setState(() {
                                  result = convertCurrency(
                                    amount,
                                    fromCurrency,
                                    toCurrency,
                                    rates,
                                  );
                                });
                              },
                              child: const Text(
                                'Convertir',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          if (result != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Resultado: ${result!.toStringAsFixed(2)} $toCurrency',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Tasas Card
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 209, 209, 209),
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tasas Actuales',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          for (var rate in rates)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('1 ${rate.descripcion}'),
                                  Text('RD\$ ${rate.venta.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              'Actualizado: ${snapshot.data!.fechaConsulta}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
