import 'package:finance_project/models/currency.dart';

double convertCurrency(
  double amount,
  String from,
  String to,
  List<Currency> rates,
) {
  if (from == to) return amount;

  final usdRate = rates.firstWhere((r) => r.descripcion == 'USD').venta;
  final eurRate = rates.firstWhere((r) => r.descripcion == 'EUR').venta;

  double amountInDOP;

  // Step 1: convert source to DOP
  if (from == 'USD') {
    amountInDOP = amount * usdRate;
  } else if (from == 'EUR') {
    amountInDOP = amount * eurRate;
  } else {
    amountInDOP = amount; // already DOP
  }

  // Step 2: convert DOP to target
  if (to == 'USD') {
    return amountInDOP / usdRate;
  } else if (to == 'EUR') {
    return amountInDOP / eurRate;
  } else {
    return amountInDOP;
  }
}
