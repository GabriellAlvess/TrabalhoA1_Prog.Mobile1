import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdicionarFilmeScreen extends StatefulWidget {
  const AdicionarFilmeScreen({Key? key}) : super(key: key);

  @override
  _AdicionarFilmeScreenState createState() => _AdicionarFilmeScreenState();
}

class _AdicionarFilmeScreenState extends State<AdicionarFilmeScreen> {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? filmeEncontrado;
  bool isLoading = false;
  List<Map<String, dynamic>> filmesDisponiveis = [];
  final String apiKey = "fd4d360c99dda8e0e54323e0ba66535c";

  Future<void> buscarFilme(String titulo) async {
    setState(() {
      isLoading = true;
      filmeEncontrado = null;
    });

    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$titulo&language=pt-BR'));

    setState(() {
      isLoading = false;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final filme = data['results'][0];
          filmeEncontrado = {
            'titulo': filme['title'],
            'ano': filme['release_date']?.split('-')[0] ?? 'Desconhecido',
            'poster': filme['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${filme['poster_path']}'
                : ''
          };
        } else {
          filmeEncontrado = null;
        }
      }
    });
  }

  Future<void> buscarFilmesPopulares() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=pt-BR'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        setState(() {
          filmesDisponiveis = List<Map<String, dynamic>>.from(data['results'])
              .map((filme) => {
            'titulo': filme['title'],
            'ano': filme['release_date']?.split('-')[0] ?? 'Desconhecido',
            'poster': filme['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${filme['poster_path']}'
                : ''
          })
              .toList();
          filmesDisponiveis.sort((a, b) => a['titulo'].compareTo(b['titulo']));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    buscarFilmesPopulares();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar Filme")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nome do Filme",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    buscarFilme(_controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (filmeEncontrado != null)
              Card(
                child: ListTile(
                  leading: filmeEncontrado!['poster'].isNotEmpty
                      ? Image.network(
                    filmeEncontrado!['poster'],
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.movie, size: 50, color: Colors.grey),
                  title: Text(filmeEncontrado!['titulo']!),
                  subtitle: Text(filmeEncontrado!['ano']!),
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context, filmeEncontrado);
                    },
                  ),
                ),
              ),
            if (filmeEncontrado == null && !isLoading)
              Text("Nenhum filme encontrado", style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filmesDisponiveis.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: filmesDisponiveis[index]['poster'].isNotEmpty
                          ? Image.network(
                        filmesDisponiveis[index]['poster'],
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.movie, size: 50, color: Colors.grey),
                      title: Text(filmesDisponiveis[index]['titulo']),
                      subtitle: Text("Ano: ${filmesDisponiveis[index]['ano']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          Navigator.pop(context, filmesDisponiveis[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
