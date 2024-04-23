import 'package:financas_rapida/dados/categoria_dao.dart';
import 'package:financas_rapida/dados/fluxo_dao.dart';
import 'package:financas_rapida/dados/usuario_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'financasRapidasDB.db');
  // await deletarDatabase();
  return await openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(UsuarioDao.tableSql);
      db.execute(CategoriaDao.tableSql);
      db.execute(FluxoDao.tableSql);
    },
    onConfigure: (db) async {
      // await db.execute('PRAGMA journal_mode = DELETE;');
    },
    onOpen: (db) async{
      print('entrei aqui $path');
    },//
    version: 1,
  );
}

Future deletarDatabase() async {
  print('Deletando Banco de dados');
  final String path = join(await getDatabasesPath(), 'financasRapidasDB.db');
  await deleteDatabase(path);
  print('Banco Deletado');
}
