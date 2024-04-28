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
    final Database bancoDeDados = await getDatabase();
    // var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(fluxo);
    // if (itemExists.isEmpty) {
    print('A categoria não Existia.');
    return await bancoDeDados.insert(_tablename, taskMap);
  }

  edit(Fluxo fluxoEdit) async{
    final Database bancoDeDados = await getDatabase();
    Map<String, dynamic> fluxoEditMap = toMap(fluxoEdit);
      return await bancoDeDados.update(
        _tablename,
        fluxoEditMap,
        where: '$_id_fluxo = ?',
        whereArgs: [fluxoEdit.id],
      );
  }

  delete(int idFluxo) async {
    final Database bancoDeDados = await getDatabase();
    return bancoDeDados.delete(
      _tablename,
      where: '$_id_fluxo = ?',
      whereArgs: [idFluxo],
    );
  }

  Map<String, dynamic> toMap(Fluxo fluxo) {
    final Map<String, dynamic> mapaDeFluxos = Map();
    mapaDeFluxos[_id_fluxo] = fluxo.id;
    mapaDeFluxos[_ds_nome] = fluxo.dsNome;
    mapaDeFluxos[_id_categoria] = fluxo.idCategoria;
    mapaDeFluxos[_nr_valor] = fluxo.nrValor;
    mapaDeFluxos[_st_recorrente] = fluxo.stRecorrencia;
    mapaDeFluxos[_dt_inicio] = fluxo.dtInicio;
    mapaDeFluxos[_dt_final] = fluxo.dtFinal;
    mapaDeFluxos[_st_fluxo] = fluxo.stFluxo;
    return mapaDeFluxos;
  }

  Future<List<Fluxo>> findAllFluxos(int stFluxo) async {
    try {
      final Database bancoDeDados = await getDatabase();
      final List<Map<String, dynamic>> result = await bancoDeDados.query(
        _tablename,
        where: '$_st_fluxo = ?',
        whereArgs: [stFluxo],
      );
      return toList(result);
    } catch (ex) {
      throw Exception('teste');
    }
  }

  List<Fluxo> toList(List<Map<String, dynamic>> mapaDeFluxos) {
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
    return fluxos;
  }


}
