import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lista_filmes_screen.dart';

class ListasPersonalizadasScreen extends StatefulWidget {
  @override
  _ListasPersonalizadasScreenState createState() =>
      _ListasPersonalizadasScreenState();
}

class _ListasPersonalizadasScreenState
    extends State<ListasPersonalizadasScreen> {
  final TextEditingController _nomeListaController = TextEditingController();
  Map<String, List<Map<String, dynamic>>> listas = {};

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  void _carregarListas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listasJson = prefs.getString('minhas_listas');
    if (listasJson != null) {
      setState(() {
        listas = Map<String, List<Map<String, dynamic>>>.from(
          jsonDecode(listasJson).map(
                (key, value) => MapEntry(
              key,
              List<Map<String, dynamic>>.from(value),
            ),
          ),
        );
      });
    }
  }

  void _salvarListas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('minhas_listas', jsonEncode(listas));
  }

  void _criarNovaLista() {
    String nome = _nomeListaController.text.trim();
    if (nome.isNotEmpty && !listas.containsKey(nome)) {
      setState(() {
        listas[nome] = [];
        _nomeListaController.clear();
      });
      _salvarListas(); // fora do setState
    }
  }

  void _removerLista(String nome) {
    setState(() {
      listas.remove(nome);
    });
    _salvarListas(); // fora do setState
  }

  void _abrirLista(String nome) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaFilmesScreen(
          nomeLista: nome,
          filmes: listas[nome]!,
          onUpdate: (filmesAtualizados) {
            listas[nome] = filmesAtualizados;
            _salvarListas(); // salvar após alteração
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listas Personalizadas 📂"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeListaController,
              decoration: InputDecoration(
                labelText: "Nome da nova lista",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _criarNovaLista,
              icon: Icon(Icons.add),
              label: Text("Criar Lista"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: listas.isEmpty
                  ? Center(child: Text("Nenhuma lista criada ainda."))
                  : ListView(
                children: listas.keys.map((nomeLista) {
                  return Card(
                    child: ListTile(
                      title: Text(nomeLista),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerLista(nomeLista),
                      ),
                      onTap: () => _abrirLista(nomeLista),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
