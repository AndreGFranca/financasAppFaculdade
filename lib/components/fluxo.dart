import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Fluxo extends StatelessWidget {
  final int? id;
  final String dsNome;
  final double nrValor;
  final int idCategoria;
  final String dtInicio;
  final String dtFinal = '';
  final bool stFluxo;
  final bool stRecorrencia;

  Fluxo({
    super.key,
    required this.dsNome,
    required this.nrValor,
    required this.idCategoria,
    required this.dtInicio,
    required this.stFluxo,
    dtFinal,
    required this.stRecorrencia,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: stFluxo ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                offset: Offset(4, 8),
                blurStyle: BlurStyle.normal,
                blurRadius: 4), // Cor do boxShadow
          ],
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: $dsNome',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Valor: $nrValor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Data: $dtInicio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white70,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white70,
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
