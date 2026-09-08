import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  //Get Listar Postagens
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('&baseUrl?_limit=10'));

    if(response.statusCode ==200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Post.fromJson(json)).toList();
    } else{
      throw Exception('Falha ao carregar postagens do servidor.');
    }
  }

  //POST: Criar Postagem
  static Future<Post> createPost (Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(post.toJson()),
      );

      if  (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao atualizar a postagem.');
      }
  }

  //DELETE: Remover Postagem
  static Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir a postagem.');
    }
  }
}
