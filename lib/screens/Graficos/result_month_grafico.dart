import 'dart:ui';

import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/components/grafico_pizza.dart';
import 'package:financas_rapida/components/lista_fluxos.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ResultMonthGrafico extends StatefulWidget {
  const ResultMonthGrafico({super.key, required this.month});
  final String month;


  @override
  State<ResultMonthGrafico> createState() => _ResultMonthGraficoState();
}

class _ResultMonthGraficoState extends State<ResultMonthGrafico> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Orientação retrato (vertical)
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mês ${widget.month}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: Container(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 350,
                        width: 300,
                        child: GraficoPizza(month: widget.month),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 15),
                    child: Container(
                        height: 310,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54,width: 2),
                          // color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListaFluxos(month: widget.month)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
