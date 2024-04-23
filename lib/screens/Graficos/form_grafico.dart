import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dtInicioController.text =
            '${picked.year}-${picked.month}-${picked.day}';
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
                          controller: dtInicioController,
                          decoration: const InputDecoration(
                            hintText: 'dd/mm/yyyy',
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          controller: dtFinalController,
                          decoration: const InputDecoration(
                            hintText: 'dd/mm/yyyy',
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // print(nameController.text);
                            // print(int.parse(difficultyController.text));
                            // print(imageController.text);
                            // FluxoDao().save(Grafico(
                            //     dtInicio: dtInicioController.text));

                            // TaskInherited.of(widget.taskContext).newTask(
                            //     nameController.text,
                            //     imageController.text,
                            //     int.parse(difficultyController.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Consultando'),
                              ),
                            );
                            // Navigator.pop(context);
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
