import 'package:flutter/material.dart';
import '../models/tasa_credito_model.dart';

class TasaCreditoCard extends StatelessWidget {
  final TasaCredito tasa;

  const TasaCreditoCard({Key? key, required this.tasa}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildRateInfo(context),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildAllDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tasa.nombreProducto,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          tasa.entidad,
          style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildRateInfo(BuildContext context) {
    String rateDisplay;
    String rateLabel = tasa.concepto ?? 'Tasa de Interés';

    if (tasa.valor != null) {
      rateDisplay = '${tasa.valor!.toStringAsFixed(2)}${tasa.unidadValor == '%' ? '%' : ' ${tasa.unidadValor}'}';
    } else if (tasa.valorMinimo != null && tasa.valorMaximo != null) {
      rateLabel = 'Rango de Tasa';
      rateDisplay = '${tasa.valorMinimo!.toStringAsFixed(2)}% - ${tasa.valorMaximo!.toStringAsFixed(2)}%';
    } else {
      rateDisplay = 'No disponible';
    }

    return Row(
      children: [
        Icon(Icons.show_chart, color: Theme.of(context).colorScheme.primary, size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rateLabel,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                rateDisplay,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllDetails() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailsColumn([
                if (tasa.tipoTarjeta != null) _buildInfoRow(Icons.credit_card, 'Tipo Tarjeta', tasa.tipoTarjeta!),
                if (tasa.marca != null) _buildInfoRow(Icons.branding_watermark, 'Marca', tasa.marca!),
                if (tasa.moneda != null) _buildInfoRow(Icons.attach_money, 'Moneda', tasa.moneda!),
              ])),
              const VerticalDivider(width: 20, thickness: 1),
              Expanded(child: _buildDetailsColumn([
                _buildInfoRow(Icons.business, 'Tipo Entidad', tasa.tipoEntidad),
                _buildInfoRow(Icons.calendar_today, 'Período', tasa.periodo),
                if (tasa.periodicidad != null) _buildInfoRow(Icons.update, 'Periodicidad', tasa.periodicidad!),
                if (tasa.formatoTarifa != null) _buildInfoRow(Icons.format_align_center, 'Formato Tarifa', tasa.formatoTarifa!),
                if (tasa.valorMinimo != null) _buildInfoRow(Icons.arrow_downward, 'Valor Mínimo', tasa.valorMinimo!.toStringAsFixed(2)),
                if (tasa.valorMaximo != null) _buildInfoRow(Icons.arrow_upward, 'Valor Máximo', tasa.valorMaximo!.toStringAsFixed(2)),
              ])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsColumn(List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((child) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: child)).toList(),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(color: Colors.grey[800])),
            ],
          ),
        ),
      ],
    );
  }
}
