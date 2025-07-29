import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

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

// ===== SERVICIO RSS =====
class RssService {
  static const String _rssUrl = 'https://www.diariolibre.com/rss/economia.xml';

  static Future<List<Noticia>> fetchNoticias() async {
    try {
      final response = await http.get(Uri.parse(_rssUrl));

      if (response.statusCode != 200) {
        throw Exception('Error al cargar noticias: ${response.statusCode}');
      }

      final document = XmlDocument.parse(response.body);
      final items = document.findAllElements('item');

      if (items.isEmpty) {
        throw Exception('No se encontraron noticias en el feed');
      }

      return items.map((item) {
        try {
          final titulo = item.findElements('title').first.text;
          final descripcion = item.findElements('description').first.text;
          final link = item.findElements('link').first.text;
          final pubDate = item.findElements('pubDate').first.text;

          // Limpiar descripción HTML
          String resumen =
              descripcion
                  .replaceAll(RegExp(r'<[^>]*>'), '')
                  .replaceAll('&nbsp;', ' ')
                  .replaceAll('&quot;', '"')
                  .replaceAll('&amp;', '&')
                  .trim();

          if (resumen.length > 150) {
            resumen = '${resumen.substring(0, 150)}...';
          }

          // Formatear fecha
          String tiempoFormateado = _formatearTiempo(pubDate);

          return Noticia(
            titulo: titulo,
            resumen: resumen,
            fuente: 'Diario Libre',
            tiempo: tiempoFormateado,
            categoria: 'Economía',
            url: link,
          );
        } catch (e) {
          // Si hay un error procesando un ítem, lanzar un error más descriptivo
          throw Exception('Error al procesar una noticia: $e');
        }
      }).toList();
    } catch (e) {
      print('Error en fetchNoticias: $e');
      // En lugar de devolver noticias de ejemplo, relanzamos el error
      // para que sea manejado por el llamador
      rethrow;
    }
  }

  static String _formatearTiempo(String pubDate) {
    try {
      // Formato típico RSS: "Mon, 29 Jul 2024 16:30:00 +0000"
      final fecha = DateFormat(
        'EEE, dd MMM yyyy HH:mm:ss Z',
        'en_US',
      ).parse(pubDate);
      final ahora = DateTime.now();
      final diferencia = ahora.difference(fecha);

      if (diferencia.inMinutes < 60) {
        return '${diferencia.inMinutes}m';
      } else if (diferencia.inHours < 24) {
        return '${diferencia.inHours}h';
      } else {
        return '${diferencia.inDays}d';
      }
    } catch (e) {
      return '1h'; // Fallback
    }
  }
}

// ===== PANTALLA PRINCIPAL DE NOTICIAS =====
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Noticia> noticias = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarNoticias();
  }

  Future<void> _cargarNoticias() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final noticiasRss = await RssService.fetchNoticias();

      if (mounted) {
        setState(() {
          noticias = noticiasRss;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Error al cargar noticias';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Noticias Financieras'),
          centerTitle: true,
          leading: const Icon(Icons.article_outlined),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: _cargarNoticias,
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando noticias...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarNoticias,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (noticias.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay noticias disponibles'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarNoticias,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: noticias.length,
        itemBuilder: (context, index) {
          return NewCard(noticia: noticias[index]);
        },
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
                // const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.article_outlined,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  noticia.fuente,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  noticia.tiempo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(42),
                  ),
                  side: const BorderSide(color: Colors.white, width: 0),
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
