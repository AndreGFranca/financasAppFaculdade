import 'package:flutter/material.dart';

class CheckBoxBotao extends StatefulWidget {
  late bool checkBoxInput;
  final TextEditingController valor;
  final String label;
  CheckBoxBotao({super.key, required this.label, required this.valor,this.checkBoxInput = true});

  @override
  State<CheckBoxBotao> createState() => _CheckBoxBotaoState();
}

class _CheckBoxBotaoState extends State<CheckBoxBotao> {

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.valor.text = widget.checkBoxInput ? '1' : '0';
    });
    // Chama o método para carregar a lista de categorias quando o widget é iniciado
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide())
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Text(widget.label,style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18

            ),),
            Checkbox(
              value: widget.checkBoxInput,
              onChanged: (bool? value) {
                setState(
                      () {
                    widget.checkBoxInput = !widget.checkBoxInput;
                    widget.valor.text = widget.checkBoxInput ? '1' : '0';
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
