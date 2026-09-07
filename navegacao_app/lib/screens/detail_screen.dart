import 'package:flutter/material.dart';
import '../models/produto.dart';

class DetailScreen extends StatelessWidget {
  // Removido o parâmetro obrigatório do construtor para aceitar rotas nomeadas (Exercício 03)
  const DetailScreen({super.key});

  // Função para exibir o AlertDialog antes de voltar (Exercício 02)
  Future<void> _confirmarSaida(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Ação'),
        content: const Text('Deseja realmente voltar e confirmar a visualização?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    // Se o usuário confirmou na dialog, faz o pop da tela
    if (confirmar == true && context.mounted) {
      Navigator.pop(context, 'Produto confirmado com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Captura o objeto Produto enviado via arguments na rota nomeada (Exercício 03)
    final produto = ModalRoute.of(context)!.settings.arguments as Produto;

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              produto.descricao,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmarSaida(context),
                icon: const Icon(Icons.check),
                label: const Text('Voltar e Confirmar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}