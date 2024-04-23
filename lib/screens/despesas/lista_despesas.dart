import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:financas_rapida/dados/grafico_dao.dart';
import 'package:financas_rapida/screens/despesas/form_despesa.dart';
import 'package:financas_rapida/screens/rendas/form_renda.dart';
import 'package:flutter/material.dart';

class ListaDespesas extends StatefulWidget {
  const ListaDespesas({super.key});

  @override
  State<ListaDespesas> createState() => _ListaDespesasState();
}

class _ListaDespesasState extends State<ListaDespesas> {
  @override
  void initState() {
    super.initState();
      () async => await GraficoDao.testeConsulta();
    // Chama o método para carregar a lista de categorias quando o widget é iniciado
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Despesas',
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
              Color.fromRGBO(255, 82, 82, 100),
            ])),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FutureBuilder<List<Fluxo>>(
            future: FluxoDao().findAllFluxos(0),
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
                          final Fluxo despesas = items[index];
                          return despesas;
                        },
                      );
                    }
                    return const Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 128),
                          Text(
                            'Não há nenhuma Despesa',
                            style: TextStyle(fontSize: 32),
                          )
                        ],
                      ),
                    );
                  }
                  return const Text('Erro ao carregar Despesas ');
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
              builder: (newContext) => FormDespesa(),
            ),
          ).then((value) => setState(() {
            print('recarregando Tela de despesas');
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
