import 'package:flutter/material.dart';

class BlocoEstatistica extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String legenda;
  final Color cor;

  const BlocoEstatistica({super.key, required this.icone, required this.valor, required this.legenda, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [Icon(icone), Text(valor), Text(legenda)]),
      ),
    );
  }
}
