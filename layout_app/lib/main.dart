import 'package:flutter/material.dart';

void main() {
  runApp(const MeuLayoutApp());
}

class MeuLayoutApp extends StatelessWidget {
  const MeuLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Layout Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TelaDashboard(),
    );
  }
}

class TelaDashboard extends StatelessWidget {
  const TelaDashboard({super.key});

  // Método auxiliar para criar os cards de estatística (Exercício 01)
  Widget _buildCardEstatistica(IconData icone, String valor, String legenda, Color corFundo) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: corFundo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icone, size: 36, color: Colors.teal),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              legenda,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para criar os selos sobrepostos (Exercícios 05 e complementos)
  Widget _buildSelo(String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPDM - Dashboard de Observações'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Exercício 02: Alterado de .start para .center
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Resumo das Observações',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Linha 1: Cards Lado a Lado (Exercício 01: Adicionado o 3º card de Fotos)
            Row(
              children: [
                _buildCardEstatistica(
                  Icons.flutter_dash,
                  '124',
                  'Aves Vistas',
                  Colors.teal.shade100,
                ),
                const SizedBox(width: 12.0),
                _buildCardEstatistica(
                  Icons.place,
                  '181',
                  'Locais Visitados',
                  Colors.teal.shade50,
                ),
                const SizedBox(width: 12.0),
                _buildCardEstatistica(
                  Icons.camera_alt,
                  '45',
                  'Fotos',
                  Colors.teal.shade100,
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            const Text(
              'Destaque da Semana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // SOBREPOSIÇÃO usando Stack com Card (Exercícios 05 e 06)
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Exercício 06: Substituído Container simples por Card com elevation
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 48, color: Colors.amber),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Gavião-Real',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Avistado no Parque Central',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Selo Superior Direito (Raro - Vermelho)
                Positioned(
                  top: -8,
                  right: -8,
                  child: _buildSelo('Raro', Colors.red),
                ),
                // Exercício 05: Segundo selo inferior esquerdo (Confirmado - Verde)
                Positioned(
                  bottom: -8,
                  left: -8,
                  child: _buildSelo('Confirmado', Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Exercício 03: Seção "Últimos Registros"
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.list_alt, color: Colors.teal),
                      SizedBox(width: 12),
                      Text(
                        'Últimos Registros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ver'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}