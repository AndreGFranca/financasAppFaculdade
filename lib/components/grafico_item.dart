class GraficoItem {
  final String month;
  final double total_sem_despesa;
  final double total_despesa;
  final double balanco;

  GraficoItem( {
    required this.month,
    this.total_sem_despesa = 0.0, // Valor padrão para total_sem_despesa
    this.total_despesa = 0.0,     // Valor padrão para total_despesa
    this.balanco = 0.0,
  });
}
