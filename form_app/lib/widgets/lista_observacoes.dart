import 'package:flutter/material.dart';
import '../models/observacao.dart';

class ListaObservacoes extends StatelessWidget {
  final List<Observacao> observacoes;

  const ListaObservacoes({super.key, required this.observacoes});

  @override
  Widget build(BuildContext context) {
    if (observacoes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Nenhuma observação cadastrada ainda.',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: observacoes.length,
      itemBuilder: (ctx, index) {
        final obs = observacoes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.remove_red_eye, color: Colors.teal),
            ),
            title: Text(obs.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${obs.especie} • ${obs.local}\nObs: ${obs.observador}'),
            isThreeLine: true,
            trailing: Text(
              '${obs.data.day}/${obs.data.month}/${obs.data.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}