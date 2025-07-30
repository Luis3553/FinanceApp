import 'dart:convert';
import 'package:finance_project/models/currency.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CurrencyService {
  Future<CurrencyResponse> fetchCurrencies(String accessToken) async {
    final url = dotenv.env['CURRENCY_CONVERTER_API_URL']!;
    final clientId = dotenv.env['CLIENT_ID']!;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'X-IBM-Client-Id': clientId,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CurrencyResponse.fromJson(data);
    } else {
      throw Exception(
        'Error fetching rates: ${response.statusCode} ${response.body}',
      );
    }
  }
}
