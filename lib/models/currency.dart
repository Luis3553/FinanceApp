class Currency {
  final String descripcion;
  final double compra;
  final double venta;

  Currency({
    required this.descripcion,
    required this.compra,
    required this.venta,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      descripcion: json['descripcion'],
      compra: (json['compra'] as num).toDouble(),
      venta: (json['venta'] as num).toDouble(),
    );
  }
}

class CurrencyResponse {
  final List<Currency> monedas;
  final String fechaConsulta;

  CurrencyResponse({required this.monedas, required this.fechaConsulta});

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    final monedaList =
        (json['monedas']['moneda'] as List)
            .map((e) => Currency.fromJson(e))
            .toList();
    return CurrencyResponse(
      monedas: monedaList,
      fechaConsulta: json['monedas']['fechaConsulta'],
    );
  }
}
