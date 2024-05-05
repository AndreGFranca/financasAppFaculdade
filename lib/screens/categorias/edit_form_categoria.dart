import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/utils/checkbox_button.dart';
import 'package:flutter/material.dart';

class FormEditCategoria extends StatefulWidget {
  bool checkBoxInput = true;

  final Categoria categoriaEdit;
  FormEditCategoria({super.key, required this.categoriaEdit});

  @override
  State<FormEditCategoria> createState() => _FormEditCategoriaState();
}

class _FormEditCategoriaState extends State<FormEditCategoria> {
  TextEditingController dsNomeController = TextEditingController();
  TextEditingController stFluxoController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    dsNomeController.text = widget.categoriaEdit.nome;
    stFluxoController.text = widget.categoriaEdit.fluxo ? '1': '0';
    // Chama o método para carregar a lista de categorias quando o widget é iniciado
  }
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
            'Editar',
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
                          return 'Insira o nome da categoria';
                        }
                        return null;
                      },
                      controller: dsNomeController,
                      decoration: const InputDecoration(
                        hintText: 'Nome da categoria',
                        fillColor: Colors.transparent,
                        filled: true,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var categoria = Categoria(
                              dsNomeController.text,
                              stFluxoController.text == '1',
                              id: widget.categoriaEdit.id,
                            );
                            CategoriaDao().edit(categoria);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Editando a ${widget.categoriaEdit.nome}'),
                              ),
                            );
                            Navigator.pop(context, categoria);
                          }
                        },
                        child: Text('Editar'))
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
