import 'package:flutter/material.dart';
import 'minhalista.dart';
import 'vermaistarde.dart';
import 'listas_personalizadas.dart'; // <- Novo import

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBotao(
                context: context,
                texto: "Ver Filmes Favoritados",
                icone: Icons.favorite,
                cor: Colors.redAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MinhaListaScreen(favoritos: favoritos),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildBotao(
                context: context,
                texto: "Assistir Mais Tarde",
                icone: Icons.watch_later,
                cor: Colors.amber,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerMaisTardeScreen(filmesMaisTarde: filmesMaisTarde),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildBotao(
                context: context,
                texto: "Listas Personalizadas",
                icone: Icons.folder_special,
                cor: Colors.deepPurple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListasPersonalizadasScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotao({
    required BuildContext context,
    required String texto,
    required IconData icone,
    required Color cor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone, color: Colors.white),
        label: Text(
          texto,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
