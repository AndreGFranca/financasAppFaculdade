import 'package:sqflite/sqflite.dart';
import '../components/categoria.dart';
import 'database.dart';

class CategoriaDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_id_categoria INTEGER PRIMARY KEY,'
      '$_ds_nome TEXT, '
      '$_st_fluxo INTEGER'
      ')'
  ;

  static const String _tablename = 'tbCategoria';
  static const String _id_categoria = 'id';
  static const String _ds_nome = 'ds_nome';
  static const String _st_fluxo = 'st_fluxo';

  save(Categoria categoria) async {
    print('Iniciando o save: ');
    final Database bancoDeDados = await getDatabase();
    // var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(categoria);
    // if (itemExists.isEmpty) {
      print('A categoria não Existia.');
      return await bancoDeDados.insert(_tablename, taskMap);
    // } else {
    //   print('A tarefa já existia');
    //   return await bancoDeDados.update(
    //     _tablename,
    //     taskMap,
    //     where: '$_name = ?',
    //     whereArgs: [tarefa.nome],
    //   );
    // }
  }

  Map<String, dynamic> toMap(Categoria categoria) {
    print('Convertendo to map:');
    final Map<String, dynamic> mapaDeCategorias = Map();
    mapaDeCategorias[_ds_nome] = categoria.nome;
    mapaDeCategorias[_st_fluxo] = categoria.fluxo;
    print('Mapa de Tarefas: $mapaDeCategorias');
    return mapaDeCategorias;
  }

  Future<List<Categoria>> findAll() async {
      print('Acessando o findAll: ');
      final Database bancoDeDados = await getDatabase();
      final List<Map<String, dynamic>> result =
      await bancoDeDados.query(_tablename);
      print('Procurando dados no banco de dados... encontrado: $result');
      return toList(result);


  }
  Future<List<Categoria>> findAllRendas() async {
    print('Acessando o findAllRendas: ');
    final Database bancoDeDados = await getDatabase();

    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_st_fluxo = 1',
    );

    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }
  Future<List<Categoria>> findAllDespesas() async {
    print('Acessando o findAllDespesas: ');
    final Database bancoDeDados = await getDatabase();

    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_st_fluxo = 0',
    );

    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  List<Categoria> toList(List<Map<String, dynamic>> mapaDecategorias) {
    print('Convertendo to List:');
    final List<Categoria> categorias = [];
    for (Map<String, dynamic> linha in mapaDecategorias) {
      final Categoria categoria = Categoria(  linha[_ds_nome],  linha[_st_fluxo] == 1,id: linha[_id_categoria],);
      categorias.add(categoria);
    }
    print('Lista de Categorias $categorias');
    return categorias;
  }

}