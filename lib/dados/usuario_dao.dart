import 'package:sqflite/sqflite.dart';

import 'database.dart';

class UsuarioDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_ds_nome TEXT '
      ')'
  ;

  static const String _tablename = 'tbUsuario';
  static const String _ds_nome = 'ds_nome';

  saveUsuario(String nome) async {
    print('Iniciando o save: ');
    final Database bancoDeDados = await getDatabase();
    Map<String, dynamic> taskMap = toMap(nome);
    print('A usuario não Existia.');
    return await bancoDeDados.insert(_tablename, taskMap);
  }

  Map<String, dynamic> toMap(String nome) {
    print('Convertendo to map:');
    final Map<String, dynamic> mapaDeUsuarios = Map();
    mapaDeUsuarios[_ds_nome] = nome;
    print('Mapa de Tarefas: $mapaDeUsuarios');
    return mapaDeUsuarios;
  }
}