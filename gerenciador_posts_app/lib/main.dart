
import 'package:flutter/material.dart';
import 'models/post.dart';
import 'services/post_service.dart';

void main() {
  runApp(const GerenciadorPostsApp());
}

class GerenciadorPostsApp extends StatelessWidget {
  const GerenciadorPostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Posts API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPosts();
  }

  Future<void> _carregarPosts() async {
    setState(() => _isLoading = true);
    try {
      final posts = await PostService.fetchPosts();
      setState(() => _posts = posts);
    } catch (e) {
      _mostrarSnackBar('Erro ao carregar posts: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  void _abrirFormulario({Post? post}) {
    final titleController = TextEditingController(text: post?.title ?? '');
    final bodyController = TextEditingController(text: post?.body ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(post == null ? 'Novo Post (POST)' : 'Editar Post (PUT)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Conteúdo'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final novoTitle = titleController.text.trim();
              final novoBody = bodyController.text.trim();

              if (novoTitle.isEmpty || novoBody.isEmpty) return;

              if (post == null) {
                // Requisição POST
                try {
                  final novoPost = await PostService.createPost(
                    Post(title: novoTitle, body: novoBody),
                  );
                  setState(() => _posts.insert(0, novoPost));
                  _mostrarSnackBar('Post criado com sucesso (201 Created)!', Colors.green);
                } catch (e) {
                  _mostrarSnackBar(e.toString(), Colors.red);
                }
              } else {
                // Requisição PUT
                try {
                  final postAtualizado = await PostService.updatePost(
                    post.id!,
                    Post(id: post.id, title: novoTitle, body: novoBody),
                  );
                  setState(() {
                    final index = _posts.indexWhere((p) => p.id == post.id);
                    if (index != -1) _posts[index] = postAtualizado;
                  });
                  _mostrarSnackBar('Post atualizado com sucesso (200 OK)!', Colors.blue);
                } catch (e) {
                  _mostrarSnackBar(e.toString(), Colors.red);
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletarPost(int id) async {
    try {
      await PostService.deletePost(id);
      setState(() {
        _posts.removeWhere((p) => p.id == id);
      });
      _mostrarSnackBar('Post removido do servidor (200 OK)!', Colors.orange);
    } catch (e) {
      _mostrarSnackBar(e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Posts (REST API)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarPosts,
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (ctx, index) {
                  final post = _posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(post.body),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _abrirFormulario(post: post),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deletarPost(post.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}