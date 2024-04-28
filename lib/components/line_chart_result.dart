import 'package:financas_rapida/screens/Graficos/result_month_grafico.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'grafico_item.dart';

class LineChartResult extends StatefulWidget {
   LineChartResult(
      {super.key,
      required this.balancos,
      required this.rendas,
      required this.despesas,
      required this.items, this.dtMes = '', });

  final List<FlSpot> balancos;
  final List<FlSpot> rendas;
  final List<FlSpot> despesas;
  late String dtMes;

  late List<GraficoItem> items;

  @override
  State<LineChartResult> createState() => _LineChartResultState();
}

class _LineChartResultState extends State<LineChartResult> {
  @override
  Widget build(BuildContext context) {

    return LineChart(
      LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (tipsData) {
                List<LineTooltipItem?> tips = [];
                tipsData.forEach((element) {
                  var aux =
                      DateTime.parse(widget.items![element.x.toInt()].month);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      widget.dtMes = DateFormat('MM/yyyy').format(aux);
                    });
                  });

                  tips.add(
                    LineTooltipItem(
                        element.y.toStringAsFixed(2),
                        TextStyle(
                          color: element.bar.color,
                        )),
                  );
                });

                return tips;
              },
              fitInsideVertically: true,
            ),
          ),
          titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                axisNameWidget: Text(
                  'Valores',
                  style: TextStyle(fontSize: 25),
                ),
                axisNameSize: 30,
              ),
              topTitles: AxisTitles(
                axisNameWidget: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Data',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    if (widget.dtMes != '')
                      Padding(
                        padding: const EdgeInsets.only(right: 100.0),
                        child: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (newContext) => ResultMonthGrafico(month: widget.dtMes),
                                  ),
                                ).then((context) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeLeft, // Orientação retrato (vertical)
                                    DeviceOrientation.landscapeRight,
                                  ]);
                                }
                                );
                              },
                              child: Text('${widget.dtMes}')),
                        ),
                      )
                  ],
                ),
                axisNameSize: 30,
              ),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (double valor, TitleMeta titleMeta) {
                  var style = const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  );
                  Widget text;
                  DateTime data =
                      DateTime.parse(widget.items![valor.toInt()].month);
                  // Formatando a data como 'MM/yyyy'
                  String dataFormatada = DateFormat('MM/yy').format(data);
                  text = Text('$dataFormatada', style: style);

                  return SideTitleWidget(
                    axisSide: titleMeta.axisSide,
                    space: 10,
                    angle: 45,
                    child: text,
                  );
                },
              )),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
              ))),
          maxY: widget.balancos.map((FlSpot e) => e.y).reduce(
              (value, element) => value > element ? value : value += element),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.15,
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.withAlpha(95),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.5, 1])),
              barWidth: 5,
              color: Colors.green,
              spots: widget.rendas,
            ),
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.1,
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withAlpha(95),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.5, 1])),
              barWidth: 5,
              color: Colors.red,
              spots: widget.despesas,
            ),
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.1,
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                      colors: [
                        Colors.purpleAccent.withAlpha(95),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.5, 1])),
              barWidth: 5,
              color: Colors.purple,
              spots: widget.balancos,
            ),
          ]),
      duration: Duration(milliseconds: 150), // Optional
      curve: Curves.linear,
    );
  }
}
