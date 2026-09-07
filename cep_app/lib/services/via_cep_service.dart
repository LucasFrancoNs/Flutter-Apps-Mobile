import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco.dart';

class ViaCepService {
  static Future<Endereco> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      throw Exception('CEP invalido. Deve conter 8 digitos.');
    }

    final url = Uri.parse('http://viacep.com.br/ws/$cepLimpo/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dados = jsonDecode(response.body);

      if (dados.containsKey('erro') && dados['erro'] == true) {
        throw Exception('CEP não encontrado a base de dados.');
      }

      return Endereco.fromJson(dados);
    } else {
      throw Exception('Falha ao conectar com o serviço ViaCEP.');
    }
  }
}