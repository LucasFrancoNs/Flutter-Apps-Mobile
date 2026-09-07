import 'package:flutter/material.dart';
import 'widgets/cartao_estudante.dart';

void main() {
  runApp(const MeuCrachaApp());
}

class MeuCrachaApp extends StatelessWidget {
  const MeuCrachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Cracha Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PPDM - Identificacao Estudantil'),
          centerTitle: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CartaoEstudante(
            nome: 'Ana Silva Santos',
            curso: 'Desenvolvimento Mobile / PPDM',
            ra: '2026109923',
            email: 'ana.silva@estudante.edu.br',
            imagemUrl: 'https://i.pravatar.cc/300?img=1',
          ),
        ),
      ),
    );
  }
}