import 'package:financas_rapida/components/grafico_item.dart';
import 'package:financas_rapida/components/line_chart_result.dart';
import 'package:financas_rapida/dados/grafico_dao.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ResultGrafico extends StatefulWidget {
  final String dtInicio;
  final String dtFinal;
  late List<GraficoItem>? items;

  ResultGrafico(
      {super.key, required this.dtInicio, required this.dtFinal, this.items});


  @override
  State<ResultGrafico> createState() => _ResultGraficoState();
}

class _ResultGraficoState extends State<ResultGrafico> {
  String dtMes = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Resultado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(1, -0.5),
                end: Alignment(1, 0.5),
                // stops: <double>[0.2,1],
                colors: <Color>[
              Color.fromRGBO(255, 255, 255, 100),
              // Color.fromRGBO(154, 240, 124, 100),
              Color.fromRGBO(172, 209, 255, 100),
            ])),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<List<GraficoItem>>(
            future: GraficoDao().Consulta(widget.dtInicio, widget.dtFinal),
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
                  print('Finalizou');
                  print(snapshot.hasData);
                  if (snapshot.hasData && widget.items != null) {
                    if (widget.items!.isNotEmpty) {
                      List<FlSpot> despesas = [];
                      List<FlSpot> rendas = [];
                      List<FlSpot> balancos = [];
                      widget.items!.forEach((
                        GraficoItem element,
                      ) {
                        var indice = widget.items!.indexOf(element);
                        FlSpot despesa =
                            FlSpot(indice.toDouble(), element.total_despesa);
                        FlSpot renda = FlSpot(
                            indice.toDouble(), element.total_sem_despesa);
                        FlSpot balanco =
                            FlSpot(indice.toDouble(), element.balanco);

                        despesas.add(despesa);
                        rendas.add(renda);
                        balancos.add(balanco);
                      });
                      return LineChartResult(
                        balancos: balancos,
                        rendas: rendas,
                        despesas: despesas,
                        items: widget.items!,
                        dtMes: dtMes,
                      );
                    }
                    return const Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 128),
                          Text(
                            'Não há nenhum Dado',
                            style: TextStyle(fontSize: 32),
                          )
                        ],
                      ),
                    );
                  }
                  return const Text('Erro ao carregar os gráficos ');
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
