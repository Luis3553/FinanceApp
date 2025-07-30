import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<String> fetchAccessToken() async {
    final tokenUrl = dotenv.env['TOKEN_URL']!;
    final clientId = dotenv.env['CLIENT_ID']!;
    final clientSecret = dotenv.env['CLIENT_SECRET']!;
    final scope = 'scope_1';

    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
        'scope': scope,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception(
        'Failed to fetch token: ${response.statusCode} ${response.body}',
      );
    }
  }
}
