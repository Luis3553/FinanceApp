import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    final routes = ['/home', '/converter', '/goals', '/news', '/tasas', '/'];
    if (index != currentIndex && index < routes.length - 1) {
      Navigator.pushReplacementNamed(context, routes[index]);
    } else if (index == routes.length - 1) {
      // Handle logout
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Inicio'},
      {'icon': Icons.currency_exchange, 'label': 'Convertir'},
      {'icon': Icons.track_changes, 'label': 'Metas'},
      {'icon': Icons.article, 'label': 'Noticias'},
      {'icon': Icons.credit_card, 'label': 'Tasas'},
      {'icon': Icons.logout, 'label': 'Salir'},
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            // Skip the logout button in the bottom navigation
            if (index == items.length - 1) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              onTap: () => _onItemTapped(context, index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey.shade200 : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700],
                      size: 22,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle logout
          _onItemTapped(context, items.length - 1);
        },
        backgroundColor: Colors.red[50],
        elevation: 2,
        mini: true,
        child: Icon(Icons.logout, color: Colors.red[700]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
