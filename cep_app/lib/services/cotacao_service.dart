import 'dart:convert';

import 'package:http/http.dart' as http;

class CotacaoService {
  static Future<double> buscarDolar() async {
    final url = Uri.parse(
      'https://economia.awesomeapi.com.br/last/USD-BRL',
    );

    final response =
        await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dados =
          jsonDecode(response.body);

      final dolar = dados['USDBRL'];

      final valor = double.tryParse(
        dolar['bid'].toString(),
      );

      if (valor == null) {
        throw Exception(
          'Não foi possível obter a cotação.',
        );
      }

      return valor;
    } else {
      throw Exception(
        'Erro ao consultar cotação do dólar.',
      );
    }
  }
}