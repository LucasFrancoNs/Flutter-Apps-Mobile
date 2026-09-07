import 'package:flutter/material.dart';
import '../models/observacao.dart';

class FormularioObservacao extends StatefulWidget {
  final Function(Observacao) onAdicionar;

  const FormularioObservacao({super.key, required this.onAdicionar});

  @override
  State<FormularioObservacao> createState() => _FormularioObservacaoState();
}

class _FormularioObservacaoState extends State<FormularioObservacao> {
  final _tituloController = TextEditingController();
  final _especieController = TextEditingController();
  final _localController = TextEditingController();
  final _observadorController = TextEditingController();

  void _limparFormulario() {
    _tituloController.clear();
    _especieController.clear();
    _localController.clear();
    _observadorController.clear();
  }

  void _submeterFormulario() {
    final titulo = _tituloController.text.trim();
    final especie = _especieController.text.trim();
    final local = _localController.text.trim();
    final observador = _observadorController.text.trim();

    if (titulo.isEmpty || especie.isEmpty || local.isEmpty || observador.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final novaObservacao = Observacao(
      titulo: titulo,
      especie: especie,
      local: local,
      observador: observador,
      data: DateTime.now(),
    );

    widget.onAdicionar(novaObservacao);

    _limparFormulario();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _especieController.dispose();
    _localController.dispose();
    _observadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nova Observação de Campo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da Observação',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _especieController,
              decoration: const InputDecoration(
                labelText: 'Espécie/Ave',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pets),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _localController,
              decoration: const InputDecoration(
                labelText: 'Local do Avistamento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _observadorController,
              decoration: const InputDecoration(
                labelText: 'Nome do Observador',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submeterFormulario,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar Observação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: _limparFormulario,
              icon: const Icon(Icons.clear, color: Colors.grey),
              label: const Text('Limpar Campos', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}