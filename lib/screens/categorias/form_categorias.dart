import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/utils/checkbox_button.dart';
import 'package:flutter/material.dart';

class FormCategoria extends StatefulWidget {
  bool checkBoxInput = true;
  final BuildContext categoriaContext;

  FormCategoria({super.key, required this.categoriaContext});

  @override
  State<FormCategoria> createState() => _FormCategoriaState();
}

class _FormCategoriaState extends State<FormCategoria> {
  TextEditingController dsNomeController = TextEditingController();
  TextEditingController stFluxoController = TextEditingController(text: '1');

  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  bool difficultyValidator(String? value) {
    if (valueValidator(value)) {
      if (int.parse(value!) > 5 || int.parse(value) < 1) {
        return true;
      }
    }
    return false;
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
                    Color.fromRGBO(255, 125, 211, 100),
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
                    CheckBoxBotao(label: 'Renda?', valor: stFluxoController),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // print(nameController.text);
                            // print(int.parse(difficultyController.text));
                            // print(imageController.text);
                            CategoriaDao().save(Categoria(
                              dsNomeController.text,
                              stFluxoController.text == '1',
                            ));

                            // TaskInherited.of(widget.taskContext).newTask(
                            //     nameController.text,
                            //     imageController.text,
                            //     int.parse(difficultyController.text));



                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Criando uma nova Categoria'),
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
