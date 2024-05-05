import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/screens/categorias/edit_form_categoria.dart';
import 'package:flutter/material.dart';

import '../utils/dialog_alert.dart';

class Categoria extends StatefulWidget {
  final String nome;
  final bool fluxo;
  final int? id;
  late Function? onRemove;
  late Function? onEdit;

  Categoria(
    this.nome,
    this.fluxo, {
    super.key,
    this.id,
    this.onRemove,
    this.onEdit,
  });

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.fluxo ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                offset: Offset(4, 8),
                blurStyle: BlurStyle.normal,
                blurRadius: 4), // Cor do boxShadow
          ],
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${widget.nome}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    widget.fluxo ? 'Renda' : 'Despesa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (newContext) => FormEditCategoria(
                                categoriaEdit: widget,
                              )),
                    ).then((value) {
                      print(value);
                      widget.onEdit!(value);
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white70,
                  )),
              DialogAlerta(
                texto:
                    'Deseja mesmo excluir ${widget.nome} e todas as rendas/despesas atreladas a ele?',
                title: 'Confirmar',
                cancelar: () {},
                confirmar: () async {
                  print('teste');
                  await CategoriaDao().delete(widget.id!);
                  widget.onRemove!();
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white70,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
