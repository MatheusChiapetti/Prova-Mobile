
class Equacao {
  static const campo_id = '_id';
  static const campo_equacao = 'equacao';
  static const campo_resultado = 'resultado';

  int id;
  String equacao;
  int resultado;

  Equacao ({required this.id, required this.equacao, required this.resultado});
}