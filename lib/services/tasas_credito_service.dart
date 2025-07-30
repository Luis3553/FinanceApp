import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/tasa_credito_model.dart';

class TasasCreditoService {
  static const String _baseUrl = 'https://apis.sb.gob.do/estadisticas/v2';
  static const String _endpoint = '/tasas-comisiones/tarjetas-credito';

  final String _apiKey;
  final http.Client _client;

  TasasCreditoService({http.Client? client})
    : _client = client ?? http.Client(),
      _apiKey = dotenv.env['BANCO_CENTRAL_API_KEY'] ?? '' {
    developer.log(
      'TasasCreditoService initialized. API Key: ${_apiKey.isNotEmpty ? '***' : 'NOT FOUND'}',
    );
  }

  Future<TasasCreditoResponse> getTasasCredito({
    int page = 1,
    int perPage = 10,
    String? entidad,
    String? tipoTarjeta,
  }) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception('API key no configurada. Verifica tu archivo .env');
      }

      // Set default date range (last 6 months)
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM');
      final periodoFinal = dateFormat.format(now);
      final periodoInicial = dateFormat.format(DateTime(now.year, now.month - 6, 1));

      // Build query parameters
      final queryParams = <String, String>{
        'periodoInicial': periodoInicial,
        'periodoFinal': periodoFinal,
        'paginas': page.toString(),
        'registros': perPage.toString(),
      };

      if (entidad != null && entidad.isNotEmpty) {
        queryParams['entidad'] = entidad;
      } else {
        queryParams['tipoEntidad'] = tipoTarjeta ?? 'BM'; // Default to 'BM' if no type is selected
      }

      final headers = {
        'Ocp-Apim-Subscription-Key': _apiKey,
        'Content-Type': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
      };

      final uri = Uri.parse('$_baseUrl$_endpoint').replace(queryParameters: queryParams);
      developer.log('Requesting URL: $uri');

      final response = await _client.get(uri, headers: headers);

      developer.log('Respuesta del servidor: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          return TasasCreditoResponse.fromHttpResponse(response, page);
        } catch (e) {
          developer.log('Error al parsear la respuesta: $e');
          throw Exception('Formato de respuesta inválido');
        }
      } else if (response.statusCode == 401) {
        throw Exception('API key inválida o no proporcionada. Verifica tu .env y la subscripción en el portal del API.');
      } else if (response.statusCode == 404) {
        throw Exception(
          'Recurso no encontrado. Verifica la URL del endpoint: $_baseUrl$_endpoint',
        );
      } else {
        throw Exception(
          'Error al cargar las tasas de crédito: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      developer.log('Error en getTasasCredito: $e');
      rethrow;
    }
  }



  void dispose() {
    _client.close();
  }
}
