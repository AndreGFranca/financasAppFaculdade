import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:financas_rapida/screens/Graficos/result_grafico.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/checkbox_button.dart';

class FormGrafico extends StatefulWidget {
  FormGrafico({super.key});


  @override
  State<FormGrafico> createState() => _FormGraficoState();
}

class _FormGraficoState extends State<FormGrafico> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dtInicioController = TextEditingController();
  TextEditingController dtFinalController = TextEditingController();

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  DateTime selectedDateInitial = DateTime.now();
  DateTime selectedDateFinal = DateTime.now();

  Future<void> _selectDate(BuildContext context, TextEditingController controller,DateTime modify,bool inicial) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: modify,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
      // selectableDayPredicate: (DateTime date) {
      //   // Permite selecionar somente os meses completos
      //   return date.day == DateTime(date.year, date.month + 1, 0).day;
      // },
    );
    if (picked != null && picked != modify) {
      setState(() {
        modify = picked;
        // Formatando a data
        String formattedDate;
        if(inicial){
          formattedDate = DateFormat('yyyy-MM').format(DateTime(picked.year,picked.month,1));
        }else{
          formattedDate = DateFormat('yyyy-MM').format(picked);
        }

        controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Relatorio',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          enabled: false,
                          controller: dtInicioController,
                          decoration: const InputDecoration(
                            hintText: 'yyyy-mm',
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context,dtInicioController,selectedDateInitial, true),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          enabled: false,
                          controller: dtFinalController,
                          decoration: const InputDecoration(
                            hintText: 'yyyy-mm',
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, dtFinalController,selectedDateFinal, false),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Consultando'),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) => ResultGrafico(dtInicio:  dtInicioController.text,dtFinal:  dtFinalController.text,),
                              ),
                            ).then((context) {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp, // Orientação retrato (vertical)
                                DeviceOrientation.portraitDown,
                              ]);
                            });
                          }
                        },
                        child: Text('Consultar'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
