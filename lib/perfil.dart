import 'package:flutter/material.dart';
import 'minhalista.dart';
import 'vermaistarde.dart';

class PerfilScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoritos;
  final List<Map<String, dynamic>> filmesMaisTarde;

  PerfilScreen({required this.favoritos, required this.filmesMaisTarde});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil 👤"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MinhaListaScreen(favoritos: favoritos),
                  ),
                );
              },
              child: Text("Ver Filmes Favoritados ❤️"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerMaisTardeScreen(filmesMaisTarde: filmesMaisTarde),
                  ),
                );
              },
              child: Text("Ver Mais Tarde ⏳"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione a ação desejada para esse botão
              },
              child: Text("Outro Botão 🔘"),
            ),
          ],
        ),
      ),
    );
  }
}
