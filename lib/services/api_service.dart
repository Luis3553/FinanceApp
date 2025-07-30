import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://apis.sb.gob.do/estadisticas/v2/';
  final String _apiKey = 'dc9eaae79a3c4cd88afe25eab890d0b8'; // Tu Primary Key

  Future<List<dynamic>> obtenerDatos(String endpoint, Map<String, String> params) async {
    List<dynamic> registros = [];
    bool hasNextPage = true;
    int page = 1;

    while (hasNextPage) {
      params['paginas'] = page.toString();
      var uri = Uri.parse(_baseUrl + endpoint).replace(queryParameters: params);

      try {
        var response = await http.get(
          uri,
          headers: {
            'Ocp-Apim-Subscription-Key': _apiKey,
          },
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          registros.addAll(data);

          var paginationHeader = json.decode(response.headers['x-pagination'] ?? '{}');
          hasNextPage = paginationHeader['HasNext'] ?? false;
          if (hasNextPage) {
            page++;
          }
        } else {
          // Manejar errores de respuesta
          print('Error en la API: ${response.statusCode}');
          hasNextPage = false;
        }
      } catch (e) {
        // Manejar errores de conexión
        print('Error de conexión: $e');
        hasNextPage = false;
      }
    }
    return registros;
  }
}
