import 'package:financas_rapida/dados/grafico_dao.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultGrafico extends StatefulWidget {
  const ResultGrafico({super.key});

  @override
  State<ResultGrafico> createState() => _ResultGraficoState();
}

class _ResultGraficoState extends State<ResultGrafico> {
  @override
  void initState() {
    super.initState();
    print('teste');

    // Chama o método para carregar a lista de categorias quando o widget é iniciado
  }

  @override
  Widget build(BuildContext context) {
    print('teste2');
    // GraficoDao.testeConsulta();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight, // Orientação paisagem (horizontal)
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FutureBuilder(
        future: GraficoDao.testeConsulta(),
        builder: (buildContext, snapShot){
          return Text(
            'Resultado',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          );
        },

        )
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
          child: LineChart(
            LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      'Valores',
                      style: TextStyle(fontSize: 25),
                    ),
                    axisNameSize: 30,
                  ),
                  topTitles: AxisTitles(
                    axisNameWidget: Text(
                      'Data',
                      style: TextStyle(fontSize: 25),
                    ),
                    axisNameSize: 30,
                  ),
                ),
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            colors: [
                              Colors.greenAccent.withAlpha(95),
                              Colors.transparent
                            ],
                             begin: Alignment.bottomCenter,
                             end: Alignment.topCenter,
                            stops: [
                              0.5,
                              1
                            ])),
                    barWidth: 5,
                    color: Colors.green,
                    spots: [
                      FlSpot(10, 15),
                      FlSpot(11, 19),
                      FlSpot(12, 28),
                      FlSpot(13, 39),
                      FlSpot(14, 45),
                      FlSpot(15, 32),
                      FlSpot(16, 4),
                      FlSpot(17, 57),
                    ],
                  ),
                  LineChartBarData(
                    isCurved: true,
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            colors: [
                              Colors.redAccent.withAlpha(95),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                              0.5,
                              1
                            ])),
                    barWidth: 5,
                    color: Colors.red,
                    spots: [
                      FlSpot(10, 21),
                      FlSpot(11, 35),
                      FlSpot(12, 64),
                      FlSpot(13, 12),
                      FlSpot(14, 11),
                      FlSpot(15, 5),
                      FlSpot(16, 1),
                      FlSpot(17, 34),
                    ],
                  ),
                ]),
            duration: Duration(milliseconds: 150), // Optional
            curve: Curves.linear,
          ),
        ),
      ),
    );
  }
}
