import 'package:flutter/material.dart';

import 'models/post.dart';
import 'services/post_service.dart';

void main() {
  runApp(
    const GerenciadorPostsApp(),
  );
}

class GerenciadorPostsApp extends StatelessWidget {
  const GerenciadorPostsApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
  const PostsScreen({
    super.key,
  });

  @override
  State<PostsScreen> createState() =>
      _PostsScreenState();
}

class _PostsScreenState
    extends State<PostsScreen> {

  // Lista original
  List<Post> _posts = [];

  // Lista que aparece na tela
  List<Post> _postsFiltrados = [];

  bool _isLoading = true;

  // ====================================================
  // EXERCÍCIO 02
  // Campo de pesquisa
  // ====================================================

  final TextEditingController
      _pesquisaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _carregarPosts();

    // Sempre que digitar no campo,
    // executa o filtro
    _pesquisaController.addListener(
      _filtrarPosts,
    );
  }

  // ====================================================
  // CARREGAR POSTS
  // GET
  // ====================================================

  Future<void> _carregarPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resultado =
          await PostService.fetchPosts();

      setState(() {
        _posts = resultado.data;

        _postsFiltrados =
            List.from(_posts);
      });

      // ================================================
      // EXERCÍCIO 03
      // statusCode no SnackBar
      // ================================================

      _mostrarSnackBar(
        'GET realizado - Status Code: ${resultado.statusCode}',
        Colors.green,
      );
    } catch (e) {
      _mostrarSnackBar(
        'Erro: $e',
        Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ====================================================
  // EXERCÍCIO 02
  // FILTRO LOCAL
  // ====================================================

  void _filtrarPosts() {
    final texto =
        _pesquisaController.text
            .toLowerCase()
            .trim();

    setState(() {
      if (texto.isEmpty) {
        _postsFiltrados =
            List.from(_posts);
      } else {
        _postsFiltrados =
            _posts.where(
          (post) {
            return post.title
                .toLowerCase()
                .contains(texto);
          },
        ).toList();
      }
    });
  }

  // ====================================================
  // SNACKBAR
  // ====================================================

  void _mostrarSnackBar(
    String mensagem,
    Color cor,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
        ),
        backgroundColor: cor,
      ),
    );
  }

  // ====================================================
  // FORMULÁRIO
  // POST / PUT
  // ====================================================

  void _abrirFormulario({
    Post? post,
  }) {
    final titleController =
        TextEditingController(
      text: post?.title ?? '',
    );

    final bodyController =
        TextEditingController(
      text: post?.body ?? '',
    );

    showDialog(
      context: context,

      builder: (ctx) =>
          AlertDialog(
        title: Text(
          post == null
              ? 'Novo Post (POST)'
              : 'Editar Post (PUT)',
        ),

        content: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            TextField(
              controller:
                  titleController,

              decoration:
                  const InputDecoration(
                labelText: 'Título',
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextField(
              controller:
                  bodyController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Conteúdo',
                border:
                    OutlineInputBorder(),
              ),

              maxLines: 3,
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },

            child:
                const Text(
              'Cancelar',
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final novoTitle =
                  titleController.text
                      .trim();

              final novoBody =
                  bodyController.text
                      .trim();

              if (novoTitle.isEmpty ||
                  novoBody.isEmpty) {
                _mostrarSnackBar(
                  'Preencha todos os campos.',
                  Colors.red,
                );

                return;
              }

              Navigator.pop(ctx);

              // ========================================
              // POST
              // ========================================

              if (post == null) {
                try {
                  final resultado =
                      await PostService
                          .createPost(
                    Post(
                      title:
                          novoTitle,
                      body:
                          novoBody,
                    ),
                  );

                  setState(() {
                    _posts.insert(
                      0,
                      resultado.data,
                    );

                    _filtrarPosts();
                  });

                  // ==============================
                  // EXERCÍCIO 03
                  // ==============================

                  _mostrarSnackBar(
                    'POST realizado - Status Code: ${resultado.statusCode}',
                    Colors.green,
                  );
                } catch (e) {
                  _mostrarSnackBar(
                    'Erro: $e',
                    Colors.red,
                  );
                }
              }

              // ========================================
              // PUT
              // ========================================

              else {
                try {
                  final resultado =
                      await PostService
                          .updatePost(
                    post.id!,

                    Post(
                      id: post.id,
                      title:
                          novoTitle,
                      body:
                          novoBody,
                    ),
                  );

                  setState(() {
                    final index =
                        _posts.indexWhere(
                      (p) =>
                          p.id ==
                          post.id,
                    );

                    if (index != -1) {
                      _posts[index] =
                          resultado.data;
                    }

                    _filtrarPosts();
                  });

                  // ==============================
                  // EXERCÍCIO 03
                  // ==============================

                  _mostrarSnackBar(
                    'PUT realizado - Status Code: ${resultado.statusCode}',
                    Colors.blue,
                  );
                } catch (e) {
                  _mostrarSnackBar(
                    'Erro: $e',
                    Colors.red,
                  );
                }
              }
            },

            child:
                const Text(
              'Salvar',
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // EXERCÍCIO 01
  // CONFIRMAÇÃO ANTES DO DELETE
  // ====================================================

  Future<void> _confirmarDelete(
    Post post,
  ) async {
    final confirmar =
        await showDialog<bool>(
      context: context,

      builder: (ctx) {
        return AlertDialog(
          title:
              const Text(
            'Confirmar exclusão',
          ),

          content: Text(
            'Tem certeza que deseja excluir o post:\n\n"${post.title}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  ctx,
                  false,
                );
              },

              child:
                  const Text(
                'Cancelar',
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(
                  ctx,
                  true,
                );
              },

              icon:
                  const Icon(
                Icons.delete,
              ),

              label:
                  const Text(
                'Excluir',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,

                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        );
      },
    );

    // Só exclui caso confirme
    if (confirmar == true) {
      await _deletarPost(
        post.id!,
      );
    }
  }

  // ====================================================
  // DELETE
  // ====================================================

  Future<void> _deletarPost(
    int id,
  ) async {
    try {
      final statusCode =
          await PostService.deletePost(
        id,
      );

      setState(() {
        _posts.removeWhere(
          (p) => p.id == id,
        );

        _filtrarPosts();
      });

      // ================================================
      // EXERCÍCIO 03
      // ================================================

      _mostrarSnackBar(
        'DELETE realizado - Status Code: $statusCode',
        Colors.orange,
      );
    } catch (e) {
      _mostrarSnackBar(
        'Erro: $e',
        Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _pesquisaController.dispose();

    super.dispose();
  }

  // ====================================================
  // TELA
  // ====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(

      // ================================================
      // APPBAR + EXERCÍCIO 02
      // ================================================

      appBar: AppBar(
        backgroundColor:
            Colors.deepPurple,

        foregroundColor:
            Colors.white,

        title: Column(
          children: [
            const Text(
              'Gerenciador de Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            // ==========================================
            // CAMPO DE PESQUISA
            // ==========================================

            SizedBox(
              height: 40,

              child: TextField(
                controller:
                    _pesquisaController,

                style:
                    const TextStyle(
                  color: Colors.black,
                ),

                decoration:
                    InputDecoration(
                  hintText:
                      'Pesquisar pelo título...',

                  prefixIcon:
                      const Icon(
                    Icons.search,
                  ),

                  suffixIcon:
                      _pesquisaController
                              .text
                              .isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(
                                Icons.clear,
                              ),

                              onPressed:
                                  () {
                                _pesquisaController
                                    .clear();
                              },
                            )
                          : null,

                  filled: true,

                  fillColor:
                      Colors.white,

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 5,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),

        toolbarHeight: 100,
        centerTitle: true,
      ),

      // ================================================
      // CORPO
      // ================================================

      body: _isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : RefreshIndicator(
              onRefresh:
                  _carregarPosts,

              child:
                  _postsFiltrados
                          .isEmpty

                      ? ListView(
                          children: const [
                            SizedBox(
                              height: 200,
                            ),

                            Center(
                              child:
                                  Text(
                                'Nenhum post encontrado.',
                              ),
                            ),
                          ],
                        )

                      : ListView.builder(
                          itemCount:
                              _postsFiltrados
                                  .length,

                          itemBuilder:
                              (
                            ctx,
                            index,
                          ) {
                            final post =
                                _postsFiltrados[
                                    index];

                            return Card(
                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    12,
                                vertical:
                                    6,
                              ),

                              child:
                                  ListTile(
                                title:
                                    Text(
                                  post.title,

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                subtitle:
                                    Text(
                                  post.body,
                                ),

                                trailing:
                                    Row(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,

                                  children: [
                                    // EDITAR
                                    IconButton(
                                      icon:
                                          const Icon(
                                        Icons.edit,
                                        color:
                                            Colors.blue,
                                      ),

                                      onPressed:
                                          () {
                                        _abrirFormulario(
                                          post:
                                              post,
                                        );
                                      },
                                    ),

                                    // EXCLUIR
                                    IconButton(
                                      icon:
                                          const Icon(
                                        Icons.delete,
                                        color:
                                            Colors.red,
                                      ),

                                      // ==================
                                      // EXERCÍCIO 01
                                      // ==================

                                      onPressed:
                                          () {
                                        _confirmarDelete(
                                          post,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),

      // ================================================
      // BOTÃO PARA CRIAR POST
      // ================================================

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          _abrirFormulario();
        },

        backgroundColor:
            Colors.deepPurple,

        child:
            const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}