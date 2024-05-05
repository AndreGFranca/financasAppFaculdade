import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/screens/categorias/form_categorias.dart';
import 'package:financas_rapida/screens/rendas/form_renda.dart';
import 'package:flutter/material.dart';

class ListaCategorias extends StatefulWidget {
  const ListaCategorias({super.key});

  @override
  State<ListaCategorias> createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorias',
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
              Color.fromRGBO(255, 125, 211, 100),
            ])),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FutureBuilder<List<Categoria>>(
              future: CategoriaDao().findAll(),
              builder: (context, snapshot) {
                List<Categoria>? items = snapshot.data;
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
                            final Categoria categorias = items[index];
                            categorias.onRemove = () {
                              print('removendo $categorias');
                              items.remove(categorias);
                              setState(() {});
                            };
                            categorias.onEdit = (categoria){
                              setState(() {
                                items[index] = categoria;
                              });
                            };
                            return categorias;
                          },
                        );
                      }
                      return const Center(
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, size: 128),
                            Text(
                              'Não há nenhuma Categoria',
                              style: TextStyle(fontSize: 32),
                            )
                          ],
                        ),
                      );
                    }
                    return const Text('Erro ao carregar Categorias ');
                    break;
                }
                return Text('Erro desconhecido');
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (newContext) => FormCategoria(
                categoriaContext: context,
              ),
            ),
          ).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
