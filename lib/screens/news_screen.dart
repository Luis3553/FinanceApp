import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:url_launcher/url_launcher.dart';

// ===== MODELO DE NOTICIA =====
class Noticia {
  final String titulo;
  final String resumen;
  final String fuente;
  final String tiempo;
  final String categoria;
  final String url;

  Noticia({
    required this.titulo,
    required this.resumen,
    required this.fuente,
    required this.tiempo,
    required this.categoria,
    required this.url,
  });
}

// ===== EJEMPLOS DE DATOS =====
final List<Noticia> noticias = [
  Noticia(
    titulo: "Sube el dólar en RD",
    resumen: "El dólar alcanzó su punto más alto en lo que va del año...",
    fuente: "Diario Libre",
    tiempo: "1",
    categoria: "Economía",
    url: "https://www.diariolibre.com",
  ),
  Noticia(
    titulo: "Tips para ahorrar en inflación",
    resumen: "Descubre cómo proteger tu dinero durante tiempos difíciles...",
    fuente: "CNN Economía",
    tiempo: "2",
    categoria: "Ahorro",
    url: "https://cnne.com/ahorro",
  ),
];

// ===== PANTALLA PRINCIPAL DE NOTICIAS =====
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Noticias Financieras"),
              Text(
                "República Dominicana y LATAM",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            return NewCard(noticia: noticia);
          },
        ),
      ),
    );
  }
}

// ===== CARD INDIVIDUAL DE NOTICIA =====
class NewCard extends StatelessWidget {
  final Noticia noticia;

  const NewCard({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    noticia.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "${noticia.fuente} • ${noticia.tiempo}d",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(noticia.resumen, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(noticia.categoria),
                  backgroundColor: categoriaColor(noticia.categoria),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(noticia.url));
                  },
                  child: const Text("Leer más"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== COLORES POR CATEGORÍA =====
Color categoriaColor(String categoria) {
  switch (categoria.toLowerCase()) {
    case 'economía':
      return Colors.green;
    case 'ahorro':
      return Colors.blue;
    case 'crédito':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
