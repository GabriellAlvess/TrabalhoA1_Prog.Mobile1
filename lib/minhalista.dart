import 'package:flutter/material.dart';

class MinhaListaScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoritos;

  MinhaListaScreen({required this.favoritos});

  @override
  _MinhaListaScreenState createState() => _MinhaListaScreenState();
}

class _MinhaListaScreenState extends State<MinhaListaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Lista ❤️"),
        backgroundColor: Colors.red,
      ),
      body: widget.favoritos.isEmpty
          ? Center(
        child: Text(
          "Nenhum filme favoritado ainda 😢",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: widget.favoritos.length,
        itemBuilder: (context, index) {
          final movie = widget.favoritos[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: movie["poster_path"] != null
                  ? Image.network(
                "https://image.tmdb.org/t/p/w200${movie["poster_path"]}",
                width: 50,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.movie, size: 50, color: Colors.grey),
              title: Text(
                movie["title"] ?? "Sem título",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Ano: ${movie["release_date"]?.split('-')[0] ?? "Desconhecido"}",
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    widget.favoritos.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
