import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
      child: const Center(
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
            )
          ],
        ),
      ),
    );
  }
}
