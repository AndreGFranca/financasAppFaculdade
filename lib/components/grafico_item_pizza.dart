class GraficoItemPizza {
  final double total_categoria;
  final String ds_nome;
  final bool? st_fluxo;

  GraficoItemPizza( {
    required this.total_categoria,
    this.ds_nome = '', // Valor padrão para total_sem_despesa
    this.st_fluxo = true,    // Valor padrão para total_despesa
  });
}
