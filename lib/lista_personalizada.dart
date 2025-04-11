import 'package:flutter/material.dart';
import 'telafilmes.dart';

class ListaPersonalizadaScreen extends StatelessWidget {
  final String nomeLista;
  final List<Map<String, dynamic>> filmes;

  ListaPersonalizadaScreen({required this.nomeLista, required this.filmes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeLista),
        backgroundColor: Colors.red,
      ),
      body: filmes.isEmpty
          ? Center(
        child: Text("Nenhum filme nessa lista ainda."),
      )
          : ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          final filme = filmes[index];
          return ListTile(
            leading: filme['poster_path'] != null
                ? Image.network(
              "https://image.tmdb.org/t/p/w92${filme['poster_path']}",
              width: 50,
            )
                : Icon(Icons.movie),
            title: Text(filme['title'] ?? 'Sem título'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaFilmes(filme: filme),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
