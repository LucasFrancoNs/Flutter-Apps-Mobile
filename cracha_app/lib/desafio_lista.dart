
import 'package:flutter/material.dart';
import 'widgets/cartao_estudante.dart';

void main() {
  runApp(const DesafioListaApp());
}

class DesafioListaApp extends StatelessWidget {
  const DesafioListaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Crachás',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Estudantes'),
          centerTitle: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              children: [
                CartaoEstudante(
                  nome: 'Ana Silva Santos',
                  curso: 'Desenvolvimento Mobile / PPDM',
                  ra: '2026109923',
                  email: 'ana.silva@estudante.edu.br',
                  imagemUrl: 'https://i.pravatar.cc/300?img=5',
                ),
                SizedBox(height: 20.0),
                CartaoEstudante(
                  nome: 'Carlos Eduardo Lima',
                  curso: 'Engenharia de Software',
                  ra: '2026108841',
                  email: 'carlos.lima@estudante.edu.br',
                  imagemUrl: 'https://i.pravatar.cc/300?img=12',
                ),
                SizedBox(height: 20.0),
                CartaoEstudante(
                  nome: 'Mariana Souza Rocha',
                  curso: 'Sistemas de Informação',
                  ra: '2026107752',
                  email: 'mariana.rocha@estudante.edu.br',
                  imagemUrl: 'https://i.pravatar.cc/300?img=9',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
