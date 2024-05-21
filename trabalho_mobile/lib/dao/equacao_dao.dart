import '../model/equacao.dart';

class EquacaoDao {
  final dbProvider = DatabaseProvider.instance;

  // Função para salvar e alterar registros no banco.
  Future<bool> salvar(Equacao equacao) async {
    final db = await dbProvider.database;

    final valores = equacao.toMap(); // Mapear os dados para registro no banco de dados.

    // Se o ID não existe, faz um novo registro no banco (Função INSERT) - Criando nova tabela.
    if (equacao.id == null) {
      equacao.id = await db.insert(Equacao.nome_tabela, valores);
      return true;
    } else {
      // Se existe um ID, significa que a equação existe, então faz uma alteração no banco (Função UPDATE).
      final registrosAtualizados = await db.update(
        Equacao.nome_tabela,
        valores,
        where: '${Equacao.campo_id} = ?',
        whereArgs: [equacao.id],
      );
      return registrosAtualizados > 0;
    }
  }

  // Função para deletar um registro do banco de dados.
  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(
      Equacao.nome_tabela,
      where: '${Equacao.campo_id} = ?',
      whereArgs: [id],
    );
    return removerRegistro > 0;
  }

  // Função para listar os registros do banco de dados - Encapsular os dados e retornar uma lista.
  Future<List<Equacao>> lista({String filtro = '', String campoOrdenacao = Equacao.campo_id, bool usarOrdemDecrescente = false}) async {
    final db = await dbProvider.database;
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Equacao.campo_equacao}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }
    final resultado = await db.query(
      Equacao.nome_tabela,
      columns: [Equacao.campo_id, Equacao.campo_equacao, Equacao.campo_resultado],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Equacao.fromMap(m)).toList();
  }

  // Função para inserir uma nova equação no banco de dados.
  Future<void> inserirEquacao(Equacao equacao) async {
    try {
      final db = await dbProvider.database;
      await db.insert(Equacao.nome_tabela, equacao.toMap());
    } catch (e) {
      print('Erro ao inserir equação: $e');
    }
  }
}
