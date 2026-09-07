import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PreferenciasApp());
}

class PreferenciasApp extends StatelessWidget {
  const PreferenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configurações',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const PreferenciasPage(),
    );
  }
}

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  bool _notificacoes = false;
  String _tamanhoFonte = 'Médio';

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  // Carrega as configurações salvas do disco
  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificacoes = prefs.getBool('notificacoes') ?? false;
      _tamanhoFonte = prefs.getString('tamanhoFonte') ?? 'Médio';
    });
  }

  // Salva o switch de notificações
  Future<void> _salvarNotificacoes(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificacoes', valor);
    setState(() {
      _notificacoes = valor;
    });
  }

  // Salva a seleção do tamanho da fonte
  Future<void> _salvarTamanhoFonte(String? valor) async {
    if (valor == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tamanhoFonte', valor);
    setState(() {
      _tamanhoFonte = valor;
    });
  }

  // Exercício 01: Limpa todas as chaves salvas
  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _notificacoes = false;
      _tamanhoFonte = 'Médio';
    });
  }

  // Mapeia o texto selecionado para o tamanho em double
  double _getTamanhoFonteDouble() {
    switch (_tamanhoFonte) {
      case 'Pequeno':
        return 14.0;
      case 'Grande':
        return 28.0;
      case 'Médio':
      default:
        return 20.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Texto dinâmico (Exercício 02)
            Text(
              'Exemplo de texto',
              style: TextStyle(
                fontSize: _getTamanhoFonteDouble(),
              ),
            ),
            const SizedBox(height: 16),
            // Dropdown de tamanho da fonte (Exercício 02)
            DropdownButton<String>(
              value: _tamanhoFonte,
              items: const [
                DropdownMenuItem(value: 'Pequeno', child: Text('Pequeno')),
                DropdownMenuItem(value: 'Médio', child: Text('Médio')),
                DropdownMenuItem(value: 'Grande', child: Text('Grande')),
              ],
              onChanged: _salvarTamanhoFonte,
            ),
            const SizedBox(height: 20),
            // Botão Limpar Configurações (Exercício 01)
            FilledButton.tonal(
              onPressed: _limparConfiguracoes,
              child: const Text('Limpar Configurações'),
            ),
            const SizedBox(height: 40),
            // Switch Receber Notificações (Exercício 03)
            SwitchListTile(
              title: const Text('Receber Notificações'),
              value: _notificacoes,
              onChanged: _salvarNotificacoes,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}