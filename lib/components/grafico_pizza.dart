import 'package:financas_rapida/components/grafico_item_pizza.dart';
import 'package:financas_rapida/components/piece_pizza_chart.dart';
import 'package:financas_rapida/dados/grafico_dao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoPizza extends StatefulWidget {
  GraficoPizza({super.key, required this.month});



  final String month;
  List<GraficoItemPizza>? items;

  @override
  State<GraficoPizza> createState() => _GraficoPizzaState();
}

class _GraficoPizzaState extends State<GraficoPizza> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<GraficoItemPizza>>(
          future: GraficoDao().ConsultaMes(widget.month),
          builder: (builder, snapshot) {
            widget.items = snapshot.data;
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
                      Text('Carregaando...'),
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
                if (snapshot.hasData && widget.items != null) {
                  if (widget.items!.isNotEmpty) {
                    return PiecePizzaChart(items: widget.items!);
                  }
                  return const Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 128),
                        Text(
                          'Não há nenhuma informação',
                          style: TextStyle(fontSize: 32),
                        )
                      ],
                    ),
                  );
                }
                return const Text('Erro ao carregar os gráficos ');
                break;
            }
          }),
    );
  }
}
