import 'package:flutter/material.dart';
import 'package:trabalho_mobile/model/equacao.dart';
import 'package:trabalho_mobile/dao/equacao_dao.dart'; // Importando o DAO de Equacao

class CadastroEquacaoPage extends StatefulWidget {
  @override
  _CadastroEquacaoPageState createState() => _CadastroEquacaoPageState();
}

class _CadastroEquacaoPageState extends State<CadastroEquacaoPage> {
  late TextEditingController _controllerEquacao;
  late TextEditingController _controllerResultado;

  // Instância do DAO de Equacao para lidar com as operações de banco de dados
  final _equacaoDao = EquacaoDao();

  @override
  void initState() {
    super.initState();
    _controllerEquacao = TextEditingController();
    _controllerResultado = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Equação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllerEquacao,
              decoration: InputDecoration(labelText: 'Equação'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controllerResultado,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Resultado'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cadastrarEquacao,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _cadastrarEquacao() {
    String equacao = _controllerEquacao.text;
    int resultado = int.tryParse(_controllerResultado.text) ?? 0;
    if (equacao.isNotEmpty && resultado != 0) {
      Equacao novaEquacao = Equacao(
        id: DateTime.now().millisecondsSinceEpoch,
        equacao: equacao,
        resultado: resultado,
      );
      // Salvando a nova equação no banco de dados
      _equacaoDao.inserirEquacao(novaEquacao).then((_) {
        Navigator.pop(context); // Fecha a tela de cadastro após cadastrar a equação
      }).catchError((error) {
        // Em caso de erro, exibir um AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Ocorreu um erro ao cadastrar a equação.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos corretamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controllerEquacao.dispose();
    _controllerResultado.dispose();
    super.dispose();
  }
}
