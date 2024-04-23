import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:financas_rapida/screens/rendas/form_renda.dart';
import 'package:flutter/material.dart';

class ListaRendas extends StatefulWidget {
  const ListaRendas({super.key});

  @override
  State<ListaRendas> createState() => _ListaRendasState();
}

class _ListaRendasState extends State<ListaRendas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rendas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
          padding: const EdgeInsets.only(bottom: 80),
          child: FutureBuilder<List<Fluxo>>(
            future: FluxoDao().findAllFluxos(1),
            builder: (context, snapshot) {
              List<Fluxo>? items = snapshot.data;
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
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Fluxo rendas = items[index];
                          return rendas;
                        },
                      );
                    }
                    return const Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 128),
                          Text(
                            'Não há nenhuma Renda',
                            style: TextStyle(fontSize: 32),
                          )
                        ],
                      ),
                    );
                  }
                  return const Text('Erro ao carregar Rendas ');
                  break;
              }
              return Text('Erro desconhecido');
            },),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (newContext) => FormRenda(),
            ),
          ).then((value) => setState(() {
            print('recarregando Tela de rendas');
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
