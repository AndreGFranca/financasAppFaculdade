import 'package:sqflite/sqflite.dart';

import 'database.dart';

class UsuarioDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_ds_nome TEXT '
      ')'
  ;

  static const String _tablename = 'tbUsuario';
  static const String _ds_nome = 'ds_nome';

  Future<String> saveUsuario(String nome) async {
    final Database bancoDeDados = await getDatabase();
    Map<String, dynamic> taskMap = toMap(nome);
    await bancoDeDados.insert(_tablename, taskMap);
    return nome;
  }

  Map<String, dynamic> toMap(String nome) {
    print('Convertendo to map:');
    final Map<String, dynamic> mapaDeUsuarios = Map();
    mapaDeUsuarios[_ds_nome] = nome;
    print('Mapa de Tarefas: $mapaDeUsuarios');
    return mapaDeUsuarios;
  }

  Future<String> carregarUsuario() async{
    var nome = '';
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> result = await bancoDeDados.query(
      _tablename,
      where: '$_ds_nome <> ?',
      whereArgs: [nome],
    );
    return toUsuario(result);
  }

  String toUsuario(List<Map<String, dynamic>> mapaDeFluxos) {
    print('Convertendo to List:');
    if(mapaDeFluxos.length > 0){
      final String nome = mapaDeFluxos.first[_ds_nome];

      print('Lista de Fluxos $nome');
      return nome;
    }else{
      return '';
    }
  }
}