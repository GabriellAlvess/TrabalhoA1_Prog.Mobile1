import 'package:flutter/material.dart';

class TelaFilmes extends StatelessWidget {
  final Map<String, dynamic> filme;

  TelaFilmes({required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Filme') //filme['title'] ?? 'Detalhes do Filme'),
        ,backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filme['backdrop_path'] != null
                ? Image.network(
              "https://image.tmdb.org/t/p/w500${filme['backdrop_path']}",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.movie, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filme['title'] ?? 'Título desconhecido',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Data de Lançamento: ${filme['release_date'] ?? 'Desconhecida'}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Sinopse:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    filme['overview'] ?? 'Sem sinopse disponível.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
