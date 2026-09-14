import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<Produto> _itens = [];

  List<Produto> get itens => List.unmodifiable(_itens);

  int get quantidade => _itens.length;

  double get valorTotal {
    return _itens.fold(0.0, (total, item) => total + item.preco);
  }

  void adicionar(Produto produto) {
    _itens.add(produto);
    notifyListeners();
  }

  void remover(Produto produto) {
    _itens.remove(produto);
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}