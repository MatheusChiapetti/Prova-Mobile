import 'package:flutter/material.dart';
import 'package:trabalho_mobile/model/equacao.dart';
import 'dart:math';

class EquacoesPage extends StatefulWidget {
  @override
  _EquacoesPageState createState() => _EquacoesPageState();
}

class _EquacoesPageState extends State<EquacoesPage> {
  late Equacao _equacaoAtual;
  TextEditingController _controllerResposta = TextEditingController();

  final _equacoes = <Equacao>[
    Equacao(id: 1, equacao: "{ [ (20 * 12) + 15] / 3 }", resultado: 85),
    Equacao(id: 2, equacao: "{ [ (19 * 9) / 3] + 158 }", resultado: 215),
    Equacao(id: 3, equacao: "( 5464 * 559 ) - 1566)", resultado: 3051710),
    Equacao(id: 4, equacao: "[ (26548 / 2) * 155 ] + 158", resultado: 2056728),
    Equacao(id: 5, equacao: "{ [ (24 * 8) / 4] + 267 }", resultado: 315),
    Equacao(id: 6, equacao: "( 7345 * 621 ) - 2345", resultado: 4558300),
    Equacao(id: 7, equacao: "[ (38572 / 4) * 178 ] + 356", resultado: 1718190),
    Equacao(id: 8, equacao: "{ [ (25 * 8) / 2] + 167 }", resultado: 267),
    Equacao(id: 9, equacao: "( 8923 * 458 ) - 2589", resultado: 4084545),
    Equacao(id: 10, equacao: "[ (49632 / 3) * 245 ] + 478", resultado: 4047758),
  ];

  @override
  void initState() {
    super.initState();
    _sortearEquacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(context),
      backgroundColor: Colors.white54,
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        '2 + 2',
        style: TextStyle(
          fontWeight: FontWeight.bold, // Define o texto em negrito
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _sortearEquacao,
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _equacaoAtual.equacao,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _controllerResposta,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Digite o resultado'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _validarResultado,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),// Define a cor de fundo do botão
            ),
            child: Text('Validar Resposta'),
          ),
        ],
      ),
    );
  }

  void _sortearEquacao() {
    var random = Random();
    int num = random.nextInt(10);
    _equacaoAtual = _equacoes[num];
    setState(() {}); // Atualiza o estado para refletir a nova equação sorteada
  }

  void _validarResultado() {
    String resposta = _controllerResposta.text;
    int respostaInt = int.tryParse(resposta) ?? 0;
    if (respostaInt == _equacaoAtual.resultado) {
      // Resposta correta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta correta!')),
      );
    } else {
      // Resposta incorreta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta incorreta! Tente novamente.')),
      );
    }
  }

  @override
  void dispose() {
    _controllerResposta.dispose();
    super.dispose();
  }
}
