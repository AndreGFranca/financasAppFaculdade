import 'package:financas_rapida/dados/grafico_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fluxo.dart';

class ListaFluxos extends StatefulWidget {
  const ListaFluxos({super.key, required this.month});

  final String month;

  @override
  State<ListaFluxos> createState() => _ListaFluxosState();
}

class _ListaFluxosState extends State<ListaFluxos> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Fluxo>>(
      future: GraficoDao().ConsultaMesFluxo(widget.month),
      builder: (context, snapshot) {
        List<Fluxo>? items = snapshot.data;
        print(snapshot.connectionState);
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando...'),
                ],
              ),
            );
            break;
          case ConnectionState.waiting:
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando...'),
                ],
              ),
            );
            break;
          case ConnectionState.active:
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando...'),
                ],
              ),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasData && items != null) {
              if (items.isNotEmpty) {
                return
                  ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Fluxo fluxo = items[index];
                    return fluxo;
                  },
                );
              }
              return const Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 128),
                    Text(
                      'Não há nenhum Registro',
                      style: TextStyle(fontSize: 32),
                    )
                  ],
                ),
              );
            }
            return const Text('Erro ao carregar os dados ');
            break;
        }
        return Text('Erro desconhecido');
      },
    );
  }
}
