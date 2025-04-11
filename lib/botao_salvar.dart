import 'package:flutter/material.dart';

class ListaPersonalizada {
  final String nome;
  ListaPersonalizada({required this.nome});
}

class SalvarEmBottomSheet extends StatelessWidget {
  final List<ListaPersonalizada> listasPersonalizadas;

  const SalvarEmBottomSheet({super.key, required this.listasPersonalizadas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A272A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Salvar em...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          if (listasPersonalizadas.isNotEmpty)
            ...listasPersonalizadas.map(
                  (lista) => ListTile(
                title: Text(
                  lista.nome,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: const Icon(Icons.folder, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Salvo em "${lista.nome}"')),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Você ainda não tem listas.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white),
            title: const Text(
              'Criar nova lista',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoNovaLista(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoNovaLista(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A272A),
        title: const Text(
          'Nova Lista',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nome da lista',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              final novoNome = controller.text.trim();
              if (novoNome.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lista "$novoNome" criada!')),
                );
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }
}
