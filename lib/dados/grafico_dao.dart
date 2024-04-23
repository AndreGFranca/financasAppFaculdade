import 'database.dart';

class GraficoDao {
  // static const String tableSql = ' $_tablename('
  //     '$_dt_inicio TEXT, '
  //     '$_dt_final TEXT, '
  //     ')';

  //consulta todas as tabelas
  //"SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';";
  static String batatas = ''' Select SUBSTR(dt_inicio, 6, 2) from tbFluxo; ''';
  static String teste = '''
WITH RECURSIVE Months(month) AS (
  -- CTE recursiva para gerar todos os meses entre as datas de início e final do relatório
  SELECT strftime('%Y-%m-01', ?) AS month -- Defina a data inicial do relatório aqui
  UNION ALL
  SELECT strftime('%Y-%m-01', date(month, '+1 month'))
  FROM Months
  WHERE month < strftime('%Y-%m-01', ?) -- Defina a data final do relatório aqui
),
Balances AS (
  -- CTE para calcular o balanço para cada mês
  SELECT
    m.month,
    COALESCE(SUM(CASE WHEN f.st_fluxo = 1 THEN f.nr_valor ELSE 0 END), 0) AS total_renda,
    COALESCE(SUM(CASE WHEN f.st_fluxo = 0 THEN f.nr_valor ELSE 0 END), 0) AS total_despesa
  FROM Months m
  LEFT JOIN tbFluxo f 
  ON 
    strftime('%Y-%m', f.dt_inicio) = strftime('%Y-%m', m.month) OR
  (strftime('%Y-%m', f.dt_inicio) <= strftime('%Y-%m', m.month)
		AND ((f.dt_final = '' AND f.st_recorrente = 1)
  OR (strftime('%Y-%m', f.dt_final) >= strftime('%Y-%m', m.month) AND f.st_recorrente = 1)
  ))
  GROUP BY m.month
),
Recorrentes AS (
  -- CTE para calcular rendas e despesas recorrentes
  SELECT
     f.dt_inicio AS month,
    CASE WHEN f.st_fluxo = 1 THEN f.nr_valor ELSE -f.nr_valor END AS valor_recorrente,
	CASE WHEN f.st_fluxo = 1 
		THEN f.nr_valor * ((strftime('%Y', (SELECT month FROM Months LIMIT 1)) - strftime('%Y', f.dt_inicio)) * 12 +	strftime('%m', (SELECT month FROM Months LIMIT 1)) - strftime('%m',  f.dt_inicio)) 
		ELSE -f.nr_valor * ((strftime('%Y', (SELECT month FROM Months LIMIT 1)) - strftime('%Y',  f.dt_inicio)) * 12 + strftime('%m', (SELECT month FROM Months LIMIT 1)) - strftime('%m',  f.dt_inicio)) 
	END AS valor_recorrenteAcumulado,
	 (SELECT month FROM Months LIMIT 1) as mult
	 
  FROM $_tablename f
  WHERE f.st_recorrente = 1

  AND strftime('%Y-%m', f.dt_inicio) < (SELECT month FROM Months LIMIT 1) -- Verifica recorrência antes do início do relatório
  AND (f.dt_final IS NULL OR f.dt_final = '' 
  OR strftime('%Y-%m', f.dt_final) >= (SELECT month FROM Months ORDER BY month DESC LIMIT 1)) -- Verifica recorrência até o final do relatório
)
-- Selecionar o balanço total e calcular o saldo acumulador
SELECT
  b.month,
  total_renda 
 -- + COALESCE(SUM(valor_recorrente), 0) 
  AS total_sem_despesa, -- Total sem despesa incluindo recorrentes
  total_despesa,
 
  --COALESCE(SUM(renda.nr_valor),0) --Valor das rendas não recorrentes Anterior a data de pesquisa
--Valor das despesas não recorrentes Anterior a data de pesquisa

  COALESCE(r.valor_recorrenteAcumulado,0) + 
  SUM(total_renda) OVER (ORDER BY b.month)
  -   COALESCE(SUM(d.nr_valor),0) 
--  + valor_recorrente 
  AS balanco
--  r.*,
-- SUM(d.nr_valor) as somaDespesa,-- Balanço acumulado incluindo recorrentes
--  COALESCE(SUM(renda.nr_valor),0) as somaRenda
FROM Balances b
LEFT JOIN Recorrentes r 
ON strftime('%Y-%m', r.month) <= strftime('%Y-%m',b.month) -- Unir rendas/despesas recorrentes


LEFT JOIN $_tablename d 
ON( strftime('%Y-%m', d.dt_inicio) = strftime('%Y-%m',b.month) 
OR (
		--(SELECT strftime('%Y-%m',month) FROM Months LIMIT 1) >= strftime('%Y-%m', d.dt_inicio) 
			--AND 
			strftime('%Y-%m',b.month) >= strftime('%Y-%m', d.dt_inicio)) 
	)
AND d.st_recorrente = 0 AND d.st_fluxo = 0


LEFT JOIN $_tablename renda 
ON( strftime('%Y-%m', renda.dt_inicio) = strftime('%Y-%m',b.month) 
OR (
		--(SELECT strftime('%Y-%m',month) FROM Months LIMIT 1) >= strftime('%Y-%m', d.dt_inicio) 
			--AND 
			strftime('%Y-%m',b.month) >= strftime('%Y-%m', renda.dt_inicio)) 
	)
AND renda.st_recorrente = 0 AND renda.st_fluxo = 1

GROUP BY b.month
ORDER BY b.month;

''';
  static const String _tablename = 'tbFluxo';
  static const String _dt_inicio = 'dt_inicio';
  static const String _dt_final = 'dt_final';

  static Future testeConsulta() async {
    try{
      Map<String, dynamic> parametros = {
        'dtInicio': '2024-01-01',
        'dtFinal': '2024-12-31',
      };
      var bancoDedados = await getDatabase();
      if(bancoDedados.isOpen){
        // await bancoDedados.execute('PRAGMA busy_timeout = 100000;');
        print('Banco Aberto');
        var batata = await bancoDedados.transaction((txn) async =>  await txn.rawQuery(teste,[
          '2024-01-01',
          '2024-12-31'
        ]));
        print(teste);
        batata.forEach((element) {
          print(element);
        });
        print(batata);
        await bancoDedados.close();
      }

      //     .then(
      //         (value){
      //       print(value);
      //     }
      // );

    }catch(ex){
      print(ex.toString());
      throw Exception();
    }

  }
}