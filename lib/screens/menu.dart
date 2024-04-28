import 'package:financas_rapida/screens/Graficos/form_grafico.dart';
import 'package:financas_rapida/screens/Graficos/result_grafico.dart';
import 'package:financas_rapida/screens/categorias/lista_categorias.dart';
import 'package:financas_rapida/screens/rendas/lista_rendas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'despesas/lista_despesas.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key, required this.nome});

  final String nome;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Orientação retrato (vertical)
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(1, -0.5),
                end: Alignment(1, 1),
                // stops: <double>[0.2,1],
                colors: <Color>[
              Color.fromRGBO(255, 255, 255, 100),
              Color.fromRGBO(154, 240, 124, 100),
              Color.fromRGBO(154, 240, 124, 100),
            ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Olá, $nome!",
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'robotto',
                    fontWeight: FontWeight.bold),
              ),
              if(nome.toUpperCase() == 'RITA')
                Text(
                  "Eu te amo ❤",
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'robotto',
                      fontWeight: FontWeight.bold),
                ),
              const Text("Escolha uma das opções abaixo:"),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (newContext) => ListaRendas(),
                          ),
                        );
                        //     .then((value) => setState(() {
                        //   print('Recarregando a tela inicial');
                        // }));
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          // Define a cor do botão com base no estado
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent
                                .withOpacity(0.5); // Cor quando pressionado
                          }
                          return Colors.transparent; // Cor padrão
                        }),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.9), // Cor do boxShadow
                        ),
                        elevation: MaterialStateProperty.all<double>(
                          10,
                        ), // Altura da sombra
                      ),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black),
                          gradient: const LinearGradient(
                            begin: Alignment(1, -0.5),
                            end: Alignment(1, 1),
                            colors: <Color>[
                              Color.fromRGBO(254, 229, 0, .9),
                              Color.fromRGBO(214, 192, 0, .9),
                              Color.fromRGBO(165, 148, 0, .9),
                            ],
                          ),
                        ),
                        child: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.monetization_on,
                                size: 75,
                              ),
                            ),
                            Text(
                              "Rendas",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (newContext) => ListaDespesas(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          // Define a cor do botão com base no estado
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent
                                .withOpacity(0.5); // Cor quando pressionado
                          }
                          return Colors.transparent; // Cor padrão
                        }),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.8), // Cor do boxShadow
                        ),
                        elevation: MaterialStateProperty.all<double>(
                            8), // Altura da sombra
                      ),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black),
                          gradient: const LinearGradient(
                            begin: Alignment(1, -0.5),
                            end: Alignment(1, 1),
                            colors: <Color>[
                              Color.fromRGBO(255, 177, 177, .9),
                              Color.fromRGBO(153, 0, 0, .9),
                            ],
                          ),
                        ),
                        child: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.money_off,
                                size: 75,
                              ),
                            ),
                            Text(
                              "Despesas",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (newContext) => FormGrafico(),
                          ),
                        ).then((context) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp, // Orientação retrato (vertical)
                            DeviceOrientation.portraitDown,
                          ]);
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          // Define a cor do botão com base no estado
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent
                                .withOpacity(0.5); // Cor quando pressionado
                          }
                          return Colors.transparent; // Cor padrão
                        }),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.8), // Cor do boxShadow
                        ),
                        elevation: MaterialStateProperty.all<double>(
                            8), // Altura da sombra
                      ),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black),
                          gradient: const LinearGradient(
                            begin: Alignment(1, -0.5),
                            end: Alignment(1, 1),
                            colors: <Color>[
                              Color.fromRGBO(0, 194, 255, .9),
                              Color.fromRGBO(61, 89, 37, .9),
                            ],
                          ),
                        ),
                        child: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.query_stats,
                                size: 75,
                              ),
                            ),
                            Text(
                              "Gráficos",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (newContext) => ListaCategorias(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          // Define a cor do botão com base no estado
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent
                                .withOpacity(0.5); // Cor quando pressionado
                          }
                          return Colors.transparent; // Cor padrão
                        }),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.8), // Cor do boxShadow
                        ),
                        elevation: MaterialStateProperty.all<double>(
                            8), // Altura da sombra
                      ),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black),
                          gradient: const LinearGradient(
                            begin: Alignment(1, -0.5),
                            end: Alignment(1, 1),
                            colors: <Color>[
                              Color.fromRGBO(255, 182, 248, .9),
                              Color.fromRGBO(82, 37, 89, .9),
                            ],
                          ),
                        ),
                        child: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.bookmark_add,
                                size: 75,
                              ),
                            ),
                            Text(
                              "Categorias",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.monetization_on,
              //   size: 100,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
