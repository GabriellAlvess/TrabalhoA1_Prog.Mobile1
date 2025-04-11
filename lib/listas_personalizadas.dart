import 'package:flutter/material.dart';

class ListasPersonalizadasScreen extends StatefulWidget {
  @override
  _ListasPersonalizadasScreenState createState() => _ListasPersonalizadasScreenState();
}

class _ListasPersonalizadasScreenState extends State<ListasPersonalizadasScreen> {
  final TextEditingController _nomeListaController = TextEditingController();
  List<String> listas = [];

  void _adicionarLista() {
    String nome = _nomeListaController.text.trim();
    if (nome.isNotEmpty) {
      setState(() {
        listas.add(nome);
        _nomeListaController.clear();
      });
    }
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
              onPressed: _adicionarLista,
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
                  : ListView.builder(
                itemCount: listas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(listas[index]),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Aqui você pode abrir a lista e exibir os filmes dentro dela futuramente
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
