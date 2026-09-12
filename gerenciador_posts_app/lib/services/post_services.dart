import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiResult<T> {
  final T data;
  final int statusCode;

  ApiResult({
    required this.data,
    required this.statusCode,
  });
}

class PostService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com/posts';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // ====================================================
  // GET
  // ====================================================

  static Future<ApiResult<List<Post>>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl?_limit=10'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body =
          jsonDecode(response.body);

      final posts = body
          .map(
            (json) => Post.fromJson(json),
          )
          .toList();

      return ApiResult(
        data: posts,
        statusCode: response.statusCode,
      );
    } else {
      throw Exception(
        'Erro ${response.statusCode}: Falha ao carregar posts.',
      );
    }
  }

  // ====================================================
  // POST
  // ====================================================

  static Future<ApiResult<Post>> createPost(
    Post post,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(
        post.toJson(),
      ),
    );

    if (response.statusCode == 201) {
      final novoPost = Post.fromJson(
        jsonDecode(response.body),
      );

      return ApiResult(
        data: novoPost,
        statusCode: response.statusCode,
      );
    } else {
      throw Exception(
        'Erro ${response.statusCode}: Falha ao criar postagem.',
      );
    }
  }

  // ====================================================
  // PUT
  // ====================================================

  static Future<ApiResult<Post>> updatePost(
    int id,
    Post post,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode(
        post.toJson(),
      ),
    );

    if (response.statusCode == 200) {
      final postAtualizado = Post.fromJson(
        jsonDecode(response.body),
      );

      return ApiResult(
        data: postAtualizado,
        statusCode: response.statusCode,
      );
    } else {
      throw Exception(
        'Erro ${response.statusCode}: Falha ao atualizar postagem.',
      );
    }
  }

  // ====================================================
  // DELETE
  // ====================================================

  static Future<int> deletePost(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception(
        'Erro ${response.statusCode}: Falha ao excluir postagem.',
      );
    }
  }
}