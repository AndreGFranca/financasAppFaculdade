import 'dart:ffi';

import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:financas_rapida/screens/despesas/edit_form_despesa.dart';
import 'package:financas_rapida/screens/rendas/edit_form_renda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dialog_alert.dart';
import 'categoria.dart';

class Fluxo extends StatefulWidget {
  final int? id;
  final String dsNome;
  final double nrValor;
  final int idCategoria;
  final String dtInicio;
  late String dtFinal;
  final bool stFluxo;
  final bool stRecorrencia;

  final Categoria? categoria;
  late Function? onRemove;
  late Function? onEdit;
  final bool? isEditable;
  final bool? isDeletable;
  final bool? showCategory;

  Fluxo({
    super.key,
    required this.dsNome,
    required this.nrValor,
    required this.idCategoria,
    required this.dtInicio,
    required this.stFluxo,
    this.dtFinal = '',
    required this.stRecorrencia,
    this.id,
    this.onRemove,
    this.onEdit,
    this.categoria,
    this.isEditable = true,
    this.isDeletable = true,
    this.showCategory = false,
  });

  @override
  State<Fluxo> createState() => _FluxoState();
}

class _FluxoState extends State<Fluxo> {
  final String dtFinal = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.stFluxo ? Colors.green : Colors.red,
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
                    'Nome: ${widget.dsNome}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Valor: ${widget.nrValor}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Data: ${widget.dtInicio}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              if (widget.isEditable!)
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => widget.stFluxo
                              ? FormEditRenda(fluxoEdit: widget)
                              : FormEditDespesa(fluxoEdit: widget),
                        ),
                      ).then((value) {
                        print(value);
                        widget.onEdit!(value);
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white70,
                    )),
              if (widget.isDeletable!)
                DialogAlerta(
                  texto: 'Deseja mesmo excluir ${widget.dsNome}?',
                  title: 'Confirmar',
                  cancelar: () {},
                  confirmar: () async {
                    print('teste');
                    await FluxoDao().delete(widget.id!);
                    widget.onRemove!();
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.white70,
                  ),
                ),
              if(widget.showCategory!)
                Container(
                  width: 80,
                  child: Text(widget.categoria!.nome,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),),
                )
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.delete,
              //       color: Colors.white70,
              //     )),
            ]),
          ],
        ),
      ),
    );
  }
}
