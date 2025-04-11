import 'package:flutter/material.dart';
import 'minhalista.dart';
import 'perfil.dart';
import 'telafilmes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainScreen(toggleTheme: toggleTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  MainScreen({required this.toggleTheme});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String apiKey = "fd4d360c99dda8e0e54323e0ba66535c";
  List<dynamic> trendingMovies = [];
  List<dynamic> searchResults = [];
  List<Map<String, dynamic>> favoritos = [];
  List<Map<String, dynamic>> filmesMaisTarde = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
  }

  Future<void> fetchTrendingMovies() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey&language=pt-BR"));

      if (response.statusCode == 200) {
        setState(() {
          trendingMovies = jsonDecode(response.body)["results"];
        });
      } else {
        throw Exception("Falha ao carregar os filmes.");
      }
    } catch (e) {
      print("Erro: $e");
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=pt-BR&query=$query"));

      if (response.statusCode == 200) {
        setState(() {
          isSearching = true;
          searchResults = jsonDecode(response.body)["results"];
        });
      } else {
        throw Exception("Falha na busca de filmes.");
      }
    } catch (e) {
      print("Erro: $e");
    }
  }

  void toggleFavorito(dynamic movie) {
    setState(() {
      if (favoritos.contains(movie)) {
        favoritos.remove(movie);
      } else {
        favoritos.add(movie);
      }
    });
  }

  void toggleMaisTarde(dynamic movie) {
    setState(() {
      if (filmesMaisTarde.contains(movie)) {
        filmesMaisTarde.remove(movie);
      } else {
        filmesMaisTarde.add(movie);
      }
    });
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Buscar Filme"),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: "Digite o nome do filme"),
            onChanged: (value) {
              searchMovies(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchController.clear();
                });
                Navigator.pop(context);
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CINEBUSCA 🍿", style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilScreen(
                    filmesMaisTarde: filmesMaisTarde,
                    favoritos: favoritos,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.dark_mode, color: Colors.white),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: (isSearching ? searchResults : trendingMovies).isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: (isSearching ? searchResults : trendingMovies).length,
          itemBuilder: (context, index) {
            final movie = (isSearching ? searchResults : trendingMovies)[index];
            final isFavorito = favoritos.contains(movie);
            final isMaisTarde = filmesMaisTarde.contains(movie);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaFilmes(filme: movie),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: movie["poster_path"] != null
                                ? Image.network(
                              "https://image.tmdb.org/t/p/w200${movie["poster_path"]}",
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              color: Colors.grey[300],
                              height: 150,
                              child: Icon(Icons.movie, size: 50, color: Colors.grey),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFavorito ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorito ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () => toggleFavorito(movie),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isMaisTarde ? Icons.watch_later : Icons.watch_later_outlined,
                                    color: isMaisTarde ? Colors.yellow : Colors.white,
                                  ),
                                  onPressed: () => toggleMaisTarde(movie),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie["title"] ?? "Sem título",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.search, color: Colors.white),
        onPressed: () {
          showSearchDialog();
        },
      ),
    );
  }
}
