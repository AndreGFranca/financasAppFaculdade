import 'package:financas_rapida/dados/usuario_dao.dart';
import 'package:financas_rapida/screens/form_name.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<String>? _usuarioFuture;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  void _carregarUsuario() {
    _usuarioFuture = UsuarioDao().carregarUsuario();
    print('entrei aqui');
    _usuarioFuture!.then((usuario) {
      if (usuario != null && usuario.isNotEmpty) {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MenuPrincipal(nome: usuario),
          ),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (newContext) =>
                FormName(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              "Bem vindo!",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'robotto',
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.monetization_on,
              size: 100,
            ),
            FutureBuilder<String>(
                future: UsuarioDao().carregarUsuario(),
                builder: (builder, snapshot) {
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
                      if (snapshot.hasData && snapshot.data != '') {
                        return SizedBox.shrink();
                      }
                      return const Text('Erro ao carregar o banco ');
                      break;
                  }
                  return Text('teste');
                }),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
