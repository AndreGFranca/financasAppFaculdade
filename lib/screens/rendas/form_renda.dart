import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/checkbox_button.dart';

// const List<String> list = <String>[
//   'Categoria 1',
//   'Categoria 2',
//   'Categoria 3',
//   'Categoria 4'
// ];

class FormRenda extends StatefulWidget {
  bool checkBoxInput = true;

  Future<List<Categoria>> getListaCategoriaRenda() async {
    List<Categoria> list = await CategoriaDao().findAllRendas();
    return list;
  }

  Categoria? dropdownValue; // = 'Selecione uma categoria';

  FormRenda({super.key});

  @override
  State<FormRenda> createState() => _FormRendaState();
}

class _FormRendaState extends State<FormRenda> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dsNomeController = TextEditingController();
  TextEditingController nrValorController = TextEditingController();
  TextEditingController idCategoriaController = TextEditingController();
  TextEditingController dtInicioController = TextEditingController();
  TextEditingController dtFinalController = TextEditingController();
  TextEditingController stFluxoController = TextEditingController();
  TextEditingController stRecorrenciaController = TextEditingController();

  late Future<List<Categoria>>
      _listaCategoriaRenda; // Variável para armazenar o resultado da consulta

  @override
  void initState() {
    super.initState();
    _listaCategoriaRenda = widget.getListaCategoriaRenda();
    // Chama o método para carregar a lista de categorias quando o widget é iniciado
  }

  // Future<void> _carregarListaCategoriaRenda() async {
  //   setState(() {
  //     _listaCategoriaRenda = CategoriaDao().findAllRendas(); // Chama o método do DAO para carregar a lista de categorias
  //   });
  // }

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }
  bool categoriaValidator(Categoria? value) {
    if (value != null) {
      if(!valueValidator(value.nome)){
        return false;
      }

    }
    return true;
  }

  bool numberValidator(String? value) {

      if (!valueValidator(value)) {
        if (double.parse(value!) > 0) {
          return false;
        }
      }
      return true;
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Formatando a data
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

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
            'Cadastrar',
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
                    Color.fromRGBO(237, 255, 125, 100),
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: (String? value) {
                        if (valueValidator(value)) {
                          return 'Insira o nome da Renda';
                        }
                        return null;
                      },
                      controller: dsNomeController,
                      decoration: const InputDecoration(
                        hintText: 'Nome da Renda',
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                    FutureBuilder<List<Categoria>>(
                      future: _listaCategoriaRenda,
                      builder: (context, snapshot) {
                        List<Categoria>? items = snapshot.data;
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
                                return DropdownButtonFormField<Categoria>(
                                  value: widget.dropdownValue == ''
                                      ? null
                                      : widget.dropdownValue,
                                  isExpanded: true,
                                  validator: (Categoria? value) {
                                    if (categoriaValidator(value)) {
                                      return 'Selecione uma categoria';
                                    }
                                    return null;
                                  },
                                  hint: Text('Selecione uma categoria'),
                                  onChanged: (Categoria? value) {
                                    setState(() {
                                      print(value);
                                      // print(this.widget.dropdownValue);
                                      widget.dropdownValue = value!;
                                      idCategoriaController.text = value.id!.toString();
                                      // print(this.widget.dropdownValue);
                                    });
                                  },
                                  items: items.map<DropdownMenuItem<Categoria>>(
                                    (Categoria categoria) {
                                      return DropdownMenuItem<Categoria>(
                                        value: categoria,
                                        child: Text(categoria.nome),
                                      );
                                    },
                                  ).toList(),
                                );
                              }
                              return Center(
                                child: DropdownButtonFormField<Categoria>(
                                  isExpanded: true,
                                  validator: (Categoria? value) {
                                    if (categoriaValidator(value)) {
                                      return 'Selecione uma categoria';
                                    }
                                    return null;
                                  },
                                  hint: Text('Cadastre uma categoria'),
                                  onChanged: (Categoria? value) {
                                  },
                                  items: [],
                                ),
                              );
                            }
                            return const Text('Erro ao carregar Categorias ');
                            break;
                        }
                        return Text('Erro desconhecido');
                      },
                    ),
                    Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextFormField(
                          controller: dtInicioController,
                          enabled: false,
                          decoration: const InputDecoration(
                            hintText: 'Data de Incio',
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, dtInicioController),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                    CheckBoxBotao(
                      label: 'Recorrente',
                      valor: stRecorrenciaController,
                      checkBoxInput: true,
                    ),
                    TextFormField(
                      controller: nrValorController,
                      validator: (String? value) {
                        if (numberValidator(value)) {
                          return 'Insira o nome da Renda';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Digite o valor da renda',
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {

                            var fluxo = Fluxo(
                                dsNome: dsNomeController.text,
                                idCategoria:
                                int.parse(idCategoriaController.text),
                                nrValor: double.parse(nrValorController.text),
                                stFluxo: true,
                                stRecorrencia:
                                stRecorrenciaController.text == '1'
                                    ? true
                                    : false,
                                dtInicio: dtInicioController.text);

                            FluxoDao().save(fluxo);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Criando uma nova Renda'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Cadastrar'))
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
