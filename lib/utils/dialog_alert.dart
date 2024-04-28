import 'package:flutter/material.dart';

class DialogAlerta extends StatelessWidget {
  final Widget child;
  final String texto;
  final String title;
  final Function cancelar;
  final Function confirmar;

  const DialogAlerta({
    super.key,
    required this.texto,
    required this.child,
    required this.cancelar,
    required this.confirmar,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(texto),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                cancelar();
                return Navigator.pop(context, 'Cancel');
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: (){
                confirmar();
                return Navigator.pop(context, 'Ok');
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
