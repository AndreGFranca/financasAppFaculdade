import 'package:sqflite/sqflite.dart';

import '../components/fluxo.dart';
import 'database.dart';

class FluxoDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_id_fluxo INTEGER PRIMARY KEY, '
      '$_ds_nome TEXT, '
      '$_id_categoria INTEGER, '
      '$_nr_valor REAL, '
      '$_dt_inicio TEXT, '
      '$_dt_final TEXT, '
      '$_st_fluxo INTEGER,'
      '$_st_recorrente INTEGER,'
      'FOREIGN KEY($_id_categoria) REFERENCES tbCategoria(id)'
      ')';

  static const String _tablename = 'tbFluxo';
  static const String _id_fluxo = 'id';
  static const String _ds_nome = 'ds_nome';
  static const String _id_categoria = 'id_categoria';
  static const String _nr_valor = 'nr_valor';
  static const String _dt_inicio = 'dt_inicio';
  static const String _dt_final = 'dt_final';
  static const String _st_fluxo = 'st_fluxo';
  static const String _st_recorrente = 'st_recorrente';

  save(Fluxo fluxo) async {
    print('Iniciando o save: ');
    final Database bancoDeDados = await getDatabase();
    // var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(fluxo);
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

  Map<String, dynamic> toMap(Fluxo fluxo) {
    print('Convertendo to map:');
    final Map<String, dynamic> mapaDeFluxos = Map();
    mapaDeFluxos[_id_fluxo] = fluxo.id;
    mapaDeFluxos[_ds_nome] = fluxo.dsNome;
    mapaDeFluxos[_id_categoria] = fluxo.idCategoria;
    mapaDeFluxos[_nr_valor] = fluxo.nrValor;
    mapaDeFluxos[_st_recorrente] = fluxo.stRecorrencia;
    mapaDeFluxos[_dt_inicio] = fluxo.dtInicio;
    mapaDeFluxos[_dt_final] = fluxo.dtFinal;
    mapaDeFluxos[_st_fluxo] = fluxo.stFluxo;

    // ,  static const String _tablename = 'tbFluxo';
    // static const String _id_fluxo = 'id';
    // static const String _ds_nome = 'ds_nome';
    // static const String _id_categoria = 'id_categoria';
    // static const String _nr_valor = 'nr_valor';
    // static const String _st_recorrente = 'st_recorrente';
    // static const String _dt_inicio = 'dt_inicio';
    // static const String _dt_final = 'dt_final';
    // static const String _st_fluxo = 'st_fluxo';
    print('Mapa de Tarefas: $mapaDeFluxos');
    return mapaDeFluxos;
  }

  Future<List<Fluxo>> findAllFluxos(int stFluxo) async {
    try {
      print('Acessando o findAllRendas: ');
      final Database bancoDeDados = await getDatabase();
      final List<Map<String, dynamic>> result = await bancoDeDados.query(
        _tablename,
        where: '$_st_fluxo = ?',
        whereArgs: [stFluxo],
      );
      print('Procurando dados no banco de dados... encontrado: $result');
      return toList(result);
    } catch (ex) {
      print(ex.toString());
      throw Exception('teste');
    }
  }

  // Future<List<Categoria>> findAllRendas() async {
  //   print('Acessando o findAllRendas: ');
  //   final Database bancoDeDados = await getDatabase();
  //
  //   final List<Map<String, dynamic>> result = await bancoDeDados.query(
  //     _tablename,
  //     where: '$_st_fluxo = 1',
  //   );
  //
  //   print('Procurando dados no banco de dados... encontrado: $result');
  //   return toList(result);
  // }
  // Future<List<Categoria>> findAllDespesas() async {
  //   print('Acessando o findAllDespesas: ');
  //   final Database bancoDeDados = await getDatabase();
  //
  //   final List<Map<String, dynamic>> result = await bancoDeDados.query(
  //     _tablename,
  //     where: '$_st_fluxo = 0',
  //   );
  //
  //   print('Procurando dados no banco de dados... encontrado: $result');
  //   return toList(result);
  // }

  List<Fluxo> toList(List<Map<String, dynamic>> mapaDeFluxos) {
    print('Convertendo to List:');
    final List<Fluxo> fluxos = [];
    for (Map<String, dynamic> linha in mapaDeFluxos) {
      final Fluxo fluxo = Fluxo(
        id: linha[_id_fluxo],
        dsNome: linha[_ds_nome],
        idCategoria: linha[_id_categoria],
        nrValor: linha[_nr_valor],
        stRecorrencia: linha[_st_recorrente] == 1,
        dtInicio: linha[_dt_inicio],
        dtFinal: linha[_dt_final],
        stFluxo: linha[_st_fluxo] == 1,
      );
      fluxos.add(fluxo);
    }
    print('Lista de Fluxos $fluxos');
    return fluxos;
  }
}
