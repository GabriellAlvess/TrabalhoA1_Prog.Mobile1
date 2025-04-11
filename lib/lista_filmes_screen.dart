import 'package:flutter/material.dart';

class ListaFilmesScreen extends StatefulWidget {
  final String nomeLista;
  final List<Map<String, dynamic>> filmes;
  final Function(List<Map<String, dynamic>>) onUpdate;

  ListaFilmesScreen({
    required this.nomeLista,
    required this.filmes,
    required this.onUpdate,
  });

  @override
  _ListaFilmesScreenState createState() => _ListaFilmesScreenState();
}

class _ListaFilmesScreenState extends State<ListaFilmesScreen> {
  late List<Map<String, dynamic>> _filmes;

  @override
  void initState() {
    super.initState();
    _filmes = List.from(widget.filmes);
  }

  void _adicionarFilmeDummy() {
    setState(() {
      _filmes.add({
        'id': DateTime.now().toString(),
        'titulo': 'Novo Filme',
        'descricao': 'Descrição do filme',
        'imagem': null,
      });
      widget.onUpdate(_filmes);
    });
  }

  void _removerFilme(int index) {
    setState(() {
      _filmes.removeAt(index);
      widget.onUpdate(_filmes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeLista),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _adicionarFilmeDummy,
            icon: Icon(Icons.add),
            label: Text("Adicionar Filme"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filmes.length,
              itemBuilder: (context, index) {
                final filme = _filmes[index];
                return Card(
                  child: ListTile(
                    title: Text(filme['titulo']),
                    subtitle: Text(filme['descricao']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerFilme(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
