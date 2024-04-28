
import 'package:financas_rapida/components/categoria.dart';
import 'package:financas_rapida/components/fluxo.dart';
import 'package:financas_rapida/components/grafico_item.dart';
import 'package:financas_rapida/components/grafico_item_pizza.dart';
import 'package:intl/intl.dart';

import 'database.dart';

class GraficoDao {
  String graficoLinha = '''
  WITH RECURSIVE Months(month) AS (
      -- CTE recursiva para gerar todos os meses entre as datas de início e final do relatório
      SELECT strftime('%Y-%m-01', :dt_inicio) AS month -- Defina a data inicial do relatório aqui
      UNION ALL
      SELECT strftime('%Y-%m-01', date(month, '+1 month'))
      FROM Months
      WHERE month < strftime('%Y-%m-01', :dt_final) -- Defina a data final do relatório aqui
    ),
	RendaAnterior AS (
		SELECT coalesce((SELECT
			COALESCE(SUM(f.nr_valor), 0) as RendaMensalAnterior			
		FROM tbFluxo f
		WHERE st_fluxo = 1 AND
		st_recorrente = 0
-- 		AND strftime('%Y-%m', f.dt_inicio) = strftime('%Y-%m', m.month)
		AND f.dt_inicio < :dt_inicio
						),0) AS RendaMensalAnterior
      --GROUP BY strftime('%Y-%m', f.dt_inicio)	  
	) ,
	DespesaAnterior AS (
		SELECT coalesce((SELECT
			COALESCE(SUM(f.nr_valor), 0) as DespesaMensalAnterior			
		FROM tbFluxo f
		WHERE st_fluxo = 0 AND
		st_recorrente = 0
		AND f.dt_inicio < :dt_inicio
				),0) AS DespesaMensalAnterior
      --GROUP BY strftime('%Y-%m', f.dt_inicio)	  
	),
	RendaRecorrenteAnt AS (
		SELECT coalesce((SELECT
			COALESCE(f.nr_valor * ((
							(strftime('%Y', CASE WHEN :dt_inicio < f.dt_final OR f.dt_final = ''  THEN  :dt_inicio ELSE f.dt_final  END) - strftime('%Y', f.dt_inicio)) * 12 +	
						     strftime('%m', CASE WHEN :dt_inicio < f.dt_final OR f.dt_final = '' THEN  :dt_inicio  ELSE  f.dt_final  END) - strftime('%m',  f.dt_inicio)
							 
						  )+1) ,0) AS AcumuloRec
		FROM tbFluxo f

		WHERE st_fluxo = 1 AND
		st_recorrente = 1
		AND strftime('%Y-%m', f.dt_inicio) < strftime('%Y-%m',:dt_inicio)
		),0) AS AcumuloRec

	),
	DespesaRecorrenteAnt AS (
		SELECT coalesce((SELECT
			COALESCE(f.nr_valor * ((
							(strftime('%Y', CASE WHEN :dt_inicio < f.dt_final OR f.dt_final = ''  THEN  :dt_inicio ELSE f.dt_final  END) - strftime('%Y', f.dt_inicio)) * 12 +	
						     strftime('%m', CASE WHEN :dt_inicio < f.dt_final OR f.dt_final = '' THEN  :dt_inicio  ELSE  f.dt_final  END) - strftime('%m',  f.dt_inicio)
							 
						  )+1) ,0) AS AcumuloRec
		FROM tbFluxo f

		WHERE st_fluxo = 0 AND
		st_recorrente = 1
		AND strftime('%Y-%m', f.dt_inicio) < strftime('%Y-%m',:dt_inicio)
						),0) AS AcumuloRec
	),
	Renda AS (
		SELECT
			m.month,
			COALESCE(SUM(f.nr_valor), 0) as RendaMensal			
		FROM Months m
		LEFT JOIN tbFluxo f
		ON st_fluxo = 1 AND
		st_recorrente = 0
		AND strftime('%Y-%m', f.dt_inicio) = strftime('%Y-%m', m.month)
		AND f.dt_inicio >= :dt_inicio
      GROUP BY m.month
	  
	),
	Despesa AS (
		SELECT
			m.month,
			COALESCE(SUM(f.nr_valor), 0) as DespesaMensal
		FROM Months m
		LEFT JOIN tbFluxo f
		ON st_fluxo = 0 AND
		st_recorrente = 0
		AND strftime('%Y-%m', f.dt_inicio) = strftime('%Y-%m', m.month)
		AND f.dt_inicio >= :dt_inicio
      GROUP BY m.month
	  
	), RendaRecorrente AS (
		SELECT
			m.month,
			COALESCE(SUM(f.nr_valor), 0) as RendaMensal,
			COALESCE(f.nr_valor * ((
							(strftime('%Y', m.month) - strftime('%Y', f.dt_inicio)) * 12 +	
						     strftime('%m', m.month) - strftime('%m',  f.dt_inicio)
						  ) + 1),0) AS AcumuloRec
		FROM Months m
		LEFT JOIN tbFluxo f
		ON st_fluxo = 1 AND
		st_recorrente = 1
		AND strftime('%Y-%m', f.dt_inicio) <= strftime('%Y-%m', m.month)
		AND (m.month <= f.dt_final OR f.dt_final = '')
		AND (f.dt_inicio >= :dt_inicio OR (f.dt_final >= :dt_inicio OR f.dt_final = ''))
      GROUP BY m.month	  
	),DespesaRecorrente AS (
		SELECT
			m.month,
			COALESCE(SUM(f.nr_valor), 0) as DespesaMensal,
			COALESCE(f.nr_valor * ((
							(strftime('%Y', m.month) - strftime('%Y', f.dt_inicio)) * 12 +	
						     strftime('%m', m.month) - strftime('%m',  f.dt_inicio)
						  ) + 1),0) AS AcumuloRec
		FROM Months m
		LEFT JOIN tbFluxo f
		ON st_fluxo = 0 AND
		st_recorrente = 1
		AND strftime('%Y-%m', f.dt_inicio) <= strftime('%Y-%m', m.month)
		AND ((m.month <= f.dt_final) OR f.dt_final = '')
		AND (f.dt_inicio >= :dt_inicio OR (f.dt_final >= :dt_inicio OR f.dt_final = ''))
      GROUP BY m.month	  
	),Balanco AS (
				SELECT
			m.month,
			COALESCE(				
				r.RendaMensal
			,0)+
			COALESCE(				
				rr.RendaMensal
			,0)	AS total_sem_despesa,
			COALESCE(				
				d.DespesaMensal
			,0)+
			COALESCE(				
				dr.DespesaMensal
			,0) AS total_despesa,
			
			COALESCE(
			COALESCE(ra.RendaMensalAnterior,0) +
			COALESCE(rra.AcumuloRec,0) +
			COALESCE(-da.DespesaMensalAnterior,0) +
			COALESCE(-dra.AcumuloRec,0)+
			SUM(
				r.RendaMensal
			)OVER (ORDER BY m.month) + 
			SUM(
				rr.RendaMensal
			)OVER (ORDER BY m.month) - 
			SUM(
				d.DespesaMensal
			)OVER (ORDER BY m.month) - 
			SUM(
				dr.DespesaMensal
			) OVER (ORDER BY m.month)
			,0) AS balanco
-- 						,ra.*
-- 			,da.*
-- 			,rra.*
-- 			,dra.*
		FROM Months m
		LEFT JOIN Renda r ON r.month = m.month
		LEFT JOIN RendaRecorrente rr ON rr.month = m.month
		LEFT JOIN Despesa d ON d.month = m.month
		LEFT JOIN DespesaRecorrente dr ON dr.month = m.month
		CROSS JOIN DespesaRecorrenteAnt dra ON 1 = 1
		CROSS JOIN RendaRecorrenteAnt rra ON 1 = 1
		CROSS JOIN DespesaAnterior da ON 1 = 1
		CROSS JOIN RendaAnterior ra ON 1 = 1
	)
	select * from Balanco
  ''';

  String graficoPizza = '''
SELECT 
	SUM(f.nr_valor) AS total_categoria,
	c.ds_nome,
	f.st_fluxo	
FROM tbFluxo f
INNER JOIN tbCategoria c ON  c.id = f.id_categoria
WHERE 
	(	f.dt_inicio >= :dt_inicio 
		AND f.st_recorrente = 0 
		AND f.dt_inicio <= :dt_final) 
	OR
	( 
		f.dt_inicio <= :dt_final 
		AND	f.st_recorrente = 1
		AND (f.dt_final >= :dt_inicio OR f.dt_final = '')
	)
GROUP BY c.ds_nome, f.st_fluxo
ORDER BY f.st_fluxo ASC
  ''';

  String listaFluxo = '''
  
  SELECT f.id, f.id_categoria, f.ds_nome, f.nr_valor, f.dt_inicio, f.dt_final, f.st_fluxo, f.st_recorrente, c.ds_nome as categoria from tbFluxo f INNER JOIN tbCategoria c ON c.id = f.id_categoria
WHERE 
(f.dt_inicio >= :dt_inicio  AND f.st_recorrente = 0 AND f.dt_inicio <= :dt_final)  OR ( 
f.dt_inicio <= :dt_final AND
f.st_recorrente = 1
AND (f.dt_final >= :dt_inicio  OR f.dt_final = '')
)

  ''';

  static const String _tablename = 'tbFluxo';

  Future<List<GraficoItem>> Consulta(String dtInicio, String dtFinal) async {
      var bancoDedados = await getDatabase();

      var dataInicial = DateFormat('yyyy-MM-dd').format(DateTime(int.parse(dtInicio.split('-')[0]),int.parse(dtInicio.split('-')[1]),1));
      var dataFinal = DateFormat('yyyy-MM-dd').format(DateTime(int.parse(dtFinal.split('-')[0]),int.parse(dtFinal.split('-')[1])+1,0));
        // await bancoDedados.execute('PRAGMA busy_timeout = 100000;');
      print(dataInicial);
      print(dataFinal);
        print('Banco Aberto');
        var query = graficoLinha.replaceAll(RegExp(r':dt_inicio'),'\'$dataInicial\'' );
        query = query.replaceAll(RegExp(r':dt_final'),'\'$dataFinal\'');
        final List<Map<String, dynamic>> result =
            await bancoDedados.rawQuery(query);
        return toList(result);
  }


  List<GraficoItem> toList(List<Map<String, dynamic>> mapaDeItems) {
    print('Convertendo to List:');
    final List<GraficoItem> items = [];

    for (Map<String, dynamic> linha in mapaDeItems) {

      final GraficoItem item = GraficoItem(
        month: linha['month'],
        total_sem_despesa: double.parse(linha['total_sem_despesa'].toString()),
        total_despesa: double.parse(linha['total_despesa'].toString()),
        balanco: double.parse(linha['balanco'].toString()),
      );
      items.add(item);
    }
    print(items);
    return items;
  }

  List<GraficoItemPizza> toListPizza(List<Map<String, dynamic>> mapaDeItems) {
    print('Convertendo to List:');
    final List<GraficoItemPizza> items = [];
    for (Map<String, dynamic> linha in mapaDeItems) {
      print(linha);
      final GraficoItemPizza item = GraficoItemPizza(
        total_categoria: double.parse(linha['total_categoria'].toStringAsFixed(2)),
        st_fluxo: linha['st_fluxo'] == 1,
        ds_nome: linha['ds_nome'],
      );
      items.add(item);
    }
    return items;
  }

  List<Fluxo> toListFluxo(List<Map<String, dynamic>> mapaDeItems) {
    print('Convertendo to List:');
    final List<Fluxo> fluxos = [];
    for (Map<String, dynamic> linha in mapaDeItems) {

      final Fluxo fluxo = Fluxo(
        id: linha['id'],
        dsNome: linha['ds_nome'],
        idCategoria: linha['id_categoria'],
        nrValor: linha['nr_valor'],
        stRecorrencia: linha['st_recorrente'] == 1,
        dtInicio: linha['dt_inicio'],
        dtFinal: linha['dt_final'],
        stFluxo: linha['st_fluxo'] == 1,
        categoria: Categoria(
            linha['categoria'],
            linha['st_fluxo'] == 1,
            id: linha['id_categoria']
        ),
        isDeletable: false,
        isEditable: false,
        showCategory: true,
      );
      fluxos.add(fluxo);
    }
    print('Lista de Fluxos $fluxos');
    return fluxos;
  }

  Future<List<GraficoItemPizza>> ConsultaMes(String dtMes) async{
    var bancoDedados = await getDatabase();
    print('mes $dtMes');
    var anoAux = int.parse(dtMes.split('/')[1]);
    var mesAux = int.parse(dtMes.split('/')[0]);
    var dataInicial = DateFormat('yyyy-MM-dd').format(DateTime(anoAux,mesAux,1));
    var dataFinal = DateFormat('yyyy-MM-dd').format(DateTime(anoAux,mesAux+1,0));
    print(dataInicial);
    var query = graficoPizza.replaceAll(RegExp(r':dt_inicio'),'\'$dataInicial\'' );
    query = query.replaceAll(RegExp(r':dt_final'),'\'$dataFinal\'');
    final List<Map<String, dynamic>> result =
        await bancoDedados.rawQuery(query);
    return toListPizza(result);
  }

  Future<List<Fluxo>> ConsultaMesFluxo(String dtMes) async{
    var bancoDedados = await getDatabase();

    var anoAux = int.parse(dtMes.split('/')[1]);
    var mesAux = int.parse(dtMes.split('/')[0]);
    var dataInicial = DateFormat('yyyy-MM-dd').format(DateTime(anoAux,mesAux,1));
    var dataFinal = DateFormat('yyyy-MM-dd').format(DateTime(anoAux,mesAux+1,0));
    // await bancoDedados.execute('PRAGMA busy_timeout = 100000;');
    print(dataInicial);
    print(dataFinal);
    var query = listaFluxo.replaceAll(RegExp(r':dt_inicio'),'\'$dataInicial\'' );
    query = query.replaceAll(RegExp(r':dt_final'),'\'$dataFinal\'');
    final List<Map<String, dynamic>> result =
    await bancoDedados.rawQuery(query);
    return toListFluxo(result);

  }
}
