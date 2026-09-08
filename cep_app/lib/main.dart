import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/endereco.dart';
import 'services/via_cep_service.dart';
import 'services/cotacao_service.dart';

void main() {
  runApp(const CepApp());
}

class CepApp extends StatelessWidget {
  const CepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta CEP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// =====================================================
// FORMATADOR DO CEP
// Exercício 02
// 01001000 -> 01001-000
// =====================================================

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String numeros =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 8) {
      numeros = numeros.substring(0, 8);
    }

    String textoFormatado = numeros;

    if (numeros.length > 5) {
      textoFormatado =
          '${numeros.substring(0, 5)}-${numeros.substring(5)}';
    }

    return TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(
        offset: textoFormatado.length,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cepController = TextEditingController();

  Endereco? _enderecoResult;

  bool _isLoading = false;

  String? _errorMessage;

  // ===================================================
  // EXERCÍCIO 01
  // Histórico das últimas buscas
  // ===================================================

  final List<Endereco> _historico = [];

  // ===================================================
  // EXERCÍCIO 03
  // Cotação do dólar
  // ===================================================

  bool _isLoadingCotacao = false;

  String? _cotacaoDolar;

  String? _erroCotacao;

  // ===================================================
  // CONSULTAR CEP
  // ===================================================

  Future<void> _consultarCep() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _enderecoResult = null;
    });

    try {
      final resultado =
          await ViaCepService.buscarCep(_cepController.text);

      setState(() {
        _enderecoResult = resultado;

        // Adiciona o endereço no começo do histórico
        _historico.insert(0, resultado);

        // Mantém somente as 5 últimas pesquisas
        if (_historico.length > 5) {
          _historico.removeLast();
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ===================================================
  // CONSULTAR DÓLAR
  // Exercício 03
  // ===================================================

  Future<void> _consultarDolar() async {
    setState(() {
      _isLoadingCotacao = true;
      _cotacaoDolar = null;
      _erroCotacao = null;
    });

    try {
      final valor =
          await CotacaoService.buscarDolar();

      setState(() {
        _cotacaoDolar =
            'US\$ 1,00 = R\$ ${valor.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() {
        _erroCotacao =
            e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoadingCotacao = false;
      });
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consulta CEP (ViaCEP API)',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [
              // =========================================
              // CAMPO CEP
              // EXERCÍCIO 02
              // =========================================

              TextField(
                controller: _cepController,

                keyboardType:
                    TextInputType.number,

                inputFormatters: [
                  CepInputFormatter(),
                ],

                decoration:
                    const InputDecoration(
                  labelText:
                      'Informe o CEP',
                  hintText:
                      'Ex: 01001-000',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.location_on),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // =========================================
              // BOTÃO BUSCAR CEP
              // =========================================

              ElevatedButton.icon(
                onPressed:
                    _isLoading
                        ? null
                        : _consultarCep,

                icon:
                    const Icon(
                  Icons.search,
                ),

                label:
                    const Text(
                  'Buscar Endereço',
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.indigo,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // =========================================
              // LOADING
              // =========================================

              if (_isLoading)
                const Center(
                  child:
                      CircularProgressIndicator(),
                ),

              // =========================================
              // ERRO
              // =========================================

              if (_errorMessage != null)
                Card(
                  color:
                      Colors.red.shade50,

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16.0,
                    ),

                    child: Text(
                      _errorMessage!,

                      style:
                          const TextStyle(
                        color:
                            Colors.red,
                        fontSize:
                            16,
                      ),
                    ),
                  ),
                ),

              // =========================================
              // RESULTADO DO CEP
              // =========================================

              if (_enderecoResult != null)
                Card(
                  elevation: 4,

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16.0,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          _enderecoResult!
                              .logradouro,

                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Bairro: ${_enderecoResult!.bairro}',
                        ),

                        Text(
                          'Cidade/UF: ${_enderecoResult!.localidade} - ${_enderecoResult!.uf}',
                        ),

                        Text(
                          'CEP: ${_enderecoResult!.cep}',
                        ),
                      ],
                    ),
                  ),
                ),

              // =========================================
              // EXERCÍCIO 01
              // HISTÓRICO
              // =========================================

              const SizedBox(
                height: 30,
              ),

              const Text(
                'Últimas buscas',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              if (_historico.isEmpty)
                const Text(
                  'Nenhuma busca realizada.',
                ),

              ..._historico.map(
                (endereco) => Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.history,
                    ),

                    title: Text(
                      endereco.cep,
                    ),

                    subtitle: Text(
                      '${endereco.localidade} - ${endereco.uf}',
                    ),
                  ),
                ),
              ),

              // =========================================
              // SEPARADOR
              // =========================================

              const SizedBox(
                height: 30,
              ),

              const Divider(),

              const SizedBox(
                height: 20,
              ),

              // =========================================
              // EXERCÍCIO 03
              // COTAÇÃO DO DÓLAR
              // =========================================

              const Text(
                'Cotação do Dólar',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Consulta utilizando a AwesomeAPI',
              ),

              const SizedBox(
                height: 15,
              ),

              ElevatedButton.icon(
                onPressed:
                    _isLoadingCotacao
                        ? null
                        : _consultarDolar,

                icon:
                    const Icon(
                  Icons.attach_money,
                ),

                label:
                    const Text(
                  'Consultar Dólar',
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.indigo,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // Loading da cotação
              if (_isLoadingCotacao)
                const Center(
                  child:
                      CircularProgressIndicator(),
                ),

              // Resultado da cotação
              if (_cotacaoDolar != null)
                Card(
                  elevation: 4,

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .monetization_on,
                          size: 35,
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Text(
                          _cotacaoDolar!,

                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Erro da cotação
              if (_erroCotacao != null)
                Card(
                  color:
                      Colors.red.shade50,

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Text(
                      _erroCotacao!,

                      style:
                          const TextStyle(
                        color:
                            Colors.red,
                      ),
                    ),
                  ),
                ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}