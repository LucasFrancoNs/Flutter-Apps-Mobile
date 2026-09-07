import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/tarefa.dart';

void main() {
  runApp(const TarefasDbApp());
}

class TarefasDbApp extends StatelessWidget {
  const TarefasDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TarefasScreen(),
    );
  }
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Tarefa> _tarefas = [];
  bool _carregando = true;
  
  // Controller para o campo de busca (Exercício 03)
  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  // Atualiza a lista considerando a busca por texto (Exercício 03)
  Future<void> _atualizarLista() async {
    setState(() => _carregando = true);
    final query = _buscaController.text;
    
    // Chama o método de buscar por texto se houver algo digitado
    final dados = query.isEmpty
        ? await DatabaseHelper.instance.queryAll()
        : await DatabaseHelper.instance.search(query);

    setState(() {
      _tarefas = dados;
      _carregando = false;
    });
  }

  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) return;
    await DatabaseHelper.instance.insert(Tarefa(titulo: titulo.trim()));
    _atualizarLista();
  }

  Future<void> _alternarStatus(Tarefa tarefa) async {
    final atualizada = tarefa.copyWith(concluida: !tarefa.concluida);
    await DatabaseHelper.instance.update(atualizada);
    _atualizarLista();
  }

  Future<void> _removerTarefa(int id) async {
    await DatabaseHelper.instance.delete(id);
    _atualizarLista();
  }

  // Exercício 02: Deletar todas as tarefas do banco
  Future<void> _limparTodas() async {
    await DatabaseHelper.instance.deleteAll();
    _atualizarLista();
  }

  void _exibirDialogCadastro() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Tarefa (SQLite)'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Descrição da tarefa',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _adicionarTarefa(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistência Relacional (SQLite)'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        // Exercício 02: Botão na AppBar para apagar tudo
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Limpar tudo',
            onPressed: _limparTodas,
          ),
        ],
      ),
      body: Column(
        children: [
          // Exercício 03: Campo de busca de texto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                hintText: 'Buscar tarefa',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _buscaController.clear();
                          _atualizarLista();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              onChanged: (_) => _atualizarLista(),
            ),
          ),
          
          // Lista de tarefas ou mensagem de estado vazio
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _tarefas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa encontrada.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tarefas.length,
                        itemBuilder: (ctx, i) {
                          final t = _tarefas[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: Checkbox(
                                value: t.concluida,
                                onChanged: (_) => _alternarStatus(t),
                              ),
                              title: Text(
                                t.titulo,
                                style: TextStyle(
                                  decoration: t.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: t.concluida ? Colors.grey : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removerTarefa(t.id!),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      
      // Exercício 01: Barra inferior com o total de tarefas registradas
      bottomNavigationBar: Container(
        color: Colors.teal,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          'Total de tarefas: ${_tarefas.length}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogCadastro,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}