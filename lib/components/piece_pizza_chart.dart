import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'grafico_item_pizza.dart';

class PiecePizzaChart extends StatefulWidget {
  PiecePizzaChart({super.key, required this.items});

  int touchedIndex = -1;
  final List<GraficoItemPizza> items;

  @override
  State<PiecePizzaChart> createState() => _PiecePizzaChartState();
}

class _PiecePizzaChartState extends State<PiecePizzaChart> {
  List<PieChartSectionData> showingSections(List<GraficoItemPizza> items) {
    return List.generate(items.length, (i) {
      final isTouched = i == widget.touchedIndex;
      final fontSize = isTouched ? 14.0 : 10.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
      switch (items[i].st_fluxo) {
        case true:
          return PieChartSectionData(
            color: Colors.green,
            value: items[i].total_categoria,
            title: '${items[i].total_categoria}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black26,
              shadows: shadows,
              overflow: TextOverflow.ellipsis,
            ),
          );
        case false:
          return PieChartSectionData(
            color: Colors.red,
            value: items[i].total_categoria,
            title: '${items[i].total_categoria}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black26,
              shadows: shadows,
              overflow: TextOverflow.ellipsis,
            ),
          );
        default:
          return PieChartSectionData(
            color: Colors.purple,
            value: widget.items[i].total_categoria,
            title: '${widget.items[i].total_categoria.toStringAsFixed(2)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black26,
              shadows: shadows,
              overflow: TextOverflow.ellipsis,
            ),
          );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.items.add(GraficoItemPizza(
        total_categoria: widget.items.map((resumo) => resumo.st_fluxo == true
            ? resumo.total_categoria
            : -resumo.total_categoria)
            .reduce((value, element) =>
        value + element), st_fluxo: null, ds_nome: 'Balanço'));
    // Chama o método para carregar a lista de categorias quando o widget é iniciado
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          PieChart(PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      widget.touchedIndex = -1;
                      return;
                    }
                    widget.touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
            sections: showingSections(widget.items),
          )),
          if (widget.touchedIndex != -1)
            Center(
              child: SizedBox(
                width: 160,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.items[widget.touchedIndex].ds_nome}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis
                      ),
                    ), Text(
                      '${widget.items[widget.touchedIndex].total_categoria.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        // overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(color: Colors.green, width: 10, height: 10,),
                  Text(' Renda')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start
                ,
                children: [
                  Container(color: Colors.red, width: 10, height: 10,),
                  Text(' Despesa')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start
                ,
                children: [
                  Container(color: Colors.purple, width: 10, height: 10,),
                  Text(' Balanço')
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
