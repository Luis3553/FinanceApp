import 'dart:convert';
import 'package:http/http.dart' as http;

class TasaCredito {
  final String periodo;
  final String tipoEntidad;
  final String entidad;
  final String nombreProducto;
  final String? marca;
  final String? tipoTarjeta;
  final String? moneda;
  final String? concepto;
  final String? periodicidad;
  final String? formatoTarifa;
  final double? valor;
  final double? valorMinimo;
  final double? valorMaximo;
  final String? unidadValor;

  TasaCredito({
    required this.periodo,
    required this.tipoEntidad,
    required this.entidad,
    required this.nombreProducto,
    this.marca,
    this.tipoTarjeta,
    this.moneda,
    this.concepto,
    this.periodicidad,
    this.formatoTarifa,
    this.valor,
    this.valorMinimo,
    this.valorMaximo,
    this.unidadValor,
  });

  factory TasaCredito.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return TasaCredito(
      periodo: json['periodo'] ?? 'N/A',
      tipoEntidad: json['tipoEntidad'] ?? 'N/A',
      entidad: json['entidad'] ?? 'N/A',
      nombreProducto: json['nombreProducto'] ?? 'N/A',
      marca: json['marca'],
      tipoTarjeta: json['tipoTarjeta'],
      moneda: json['moneda'],
      concepto: json['concepto'],
      periodicidad: json['periodicidad'],
      formatoTarifa: json['formatoTarifa'],
      valor: parseDouble(json['valor']),
      valorMinimo: parseDouble(json['valorMinimo']),
      valorMaximo: parseDouble(json['valorMaximo']),
      unidadValor: json['unidadValor'],
    );
  }
}

class TasasCreditoResponse {
  final List<TasaCredito> items;
  final int totalPaginas;
  final int paginaActual;

  TasasCreditoResponse({
    required this.items,
    required this.totalPaginas,
    required this.paginaActual,
  });

  factory TasasCreditoResponse.fromHttpResponse(http.Response response, int requestedPage) {
    final List<dynamic> data = json.decode(response.body);
    final items = data.map((item) => TasaCredito.fromJson(item as Map<String, dynamic>)).toList();

    final paginationHeader = response.headers['x-pagination'];
    int totalPaginas = 1;

    if (paginationHeader != null) {
      try {
        final paginationData = json.decode(paginationHeader);
        totalPaginas = paginationData['TotalPages'] ?? 1;
      } catch (e) {
        print('Error parsing pagination header: $e');
      }
    }

    return TasasCreditoResponse(
      items: items,
      totalPaginas: totalPaginas,
      paginaActual: requestedPage,
    );
  }
}
