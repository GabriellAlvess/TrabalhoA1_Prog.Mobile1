import 'package:flutter/material.dart';

class VerMaisTardeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> filmesMaisTarde;

  VerMaisTardeScreen({required this.filmesMaisTarde});

  @override
  _VerMaisTardeScreenState createState() => _VerMaisTardeScreenState();
}

class _VerMaisTardeScreenState extends State<VerMaisTardeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ver Mais Tarde 🎬"),
        backgroundColor: Colors.red,
      ),
      body: widget.filmesMaisTarde.isEmpty
          ? Center(
        child: Text(
          "Nenhum filme marcado para assistir mais tarde 😢",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: widget.filmesMaisTarde.length,
        itemBuilder: (context, index) {
          final movie = widget.filmesMaisTarde[index];
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
                    widget.filmesMaisTarde.removeAt(index);
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
