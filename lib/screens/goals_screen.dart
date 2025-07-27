import 'package:flutter/material.dart';
import 'main_layout.dart';

class GoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Metas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Aquí puedes implementar la lógica para agregar una nueva meta
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.savings_outlined, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              const Text("No tienes metas aún", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                "Crea tu primera meta financiera para comenzar a ahorrar",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Crear primera meta",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // Navegar a la pantalla de creación de meta
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
