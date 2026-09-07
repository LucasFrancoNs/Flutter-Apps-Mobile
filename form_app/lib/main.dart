import 'package:flutter/material.dart';
import 'models/observacao.dart';
import 'widgets/formulario_observacao.dart';
import 'widgets/lista_observacoes.dart';

void main() {
  runApp(const FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Observações',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Observacao> _observacoes = [];

  void _adicionarObservacao(Observacao novaObs) {
    setState(() {
      _observacoes.add(novaObs);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Observação cadastrada com sucesso! Total de registros: ${_observacoes.length}'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Observações de Campo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FormularioObservacao(onAdicionar: _adicionarObservacao),
            const Divider(height: 30, thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Histórico de Registros',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text('${_observacoes.length} registros'),
                    backgroundColor: Colors.teal.shade50,
                  ),
                ],
              ),
            ),
            ListaObservacoes(observacoes: _observacoes),
          ],
        ),
      ),
    );
  }
}