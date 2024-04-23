import 'package:flutter/material.dart';

class FormName extends StatelessWidget {
  const FormName({super.key});


  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    print('Carreguei');
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
            ]),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Para começar...!",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'robotto',
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                controller: nameController,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: 'Digite seu Nome',
                  fillColor: Colors.transparent,
                  filled: true,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(1, 0),
                      end: Alignment(1, 1),
                      // stops: <double>[0.2,1],
                      colors: <Color>[
                        Color(0xFF00FF19),
                        // Color.fromRGBO(154, 240, 124, 100),
                        // Color(0xFF367500),
                        Color(0xFF367500),
                      ]),
                  shape: BoxShape.circle
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(CircleBorder()),
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
                  shadowColor: MaterialStatePropertyAll<Color>(Colors.transparent),
                  foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                ),
                child: const Icon(
                  Icons.arrow_forward,

                  size: 100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
