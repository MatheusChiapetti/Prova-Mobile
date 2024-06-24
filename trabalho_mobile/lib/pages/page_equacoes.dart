import 'package:flutter/material.dart';
import 'package:trabalho_mobile/model/equacao.dart';
import 'package:trabalho_mobile/database/database_provider.dart';
import 'dart:math';

import 'cadastro_equacoes.dart';

class EquacoesPage extends StatefulWidget {
  @override
  _EquacoesPageState createState() => _EquacoesPageState();
}

class _EquacoesPageState extends State<EquacoesPage> {
  late Equacao _equacaoAtual;
  TextEditingController _controllerResposta = TextEditingController();

  final _dao = EquacaoDao(); // Instância do DAO para lidar com as operações do banco de dados.

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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _fragment,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ConsultaCepFragment.title),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: CidadesFragment.title),
        ],
        onTap: (int newIndex) {
          if(newIndex != _fragment) {
            setState(() {
              _fragment = newIndex;
            });
          }

        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        '2 + 2',
        style: TextStyle(
          fontWeight: FontWeight.bold,
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
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            child: Text('Validar Resposta'),
          ),
          ElevatedButton(
            onPressed: _abrirCadastro,
            child: Text('Cadastrar Equação'),
          ),
        ],
      ),
    );
  }

  void _abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroEquacaoPage()),
    );
  }

  void _sortearEquacao() async {
    final List<Equacao> equacoes = await _dao.listarEquacoes();
    final random = Random();
    final int num = random.nextInt(equacoes.length);
    _equacaoAtual = equacoes[num];
    setState(() {}); // Atualiza o estado para refletir a nova equação sorteada
  }

  void _validarResultado() {
    String resposta = _controllerResposta.text;
    int respostaInt = int.tryParse(resposta) ?? 0;
    if (respostaInt == _equacaoAtual.resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta correta!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta incorreta! Tente novamente.')),
      );
    }
  }

  Widget _buildBody() => _fragment == 0 ? ConsultaCepFragment() : CidadesFragment();

  Widget? _buildFloatingActionButton() {
    if(_fragment == 0) {
      return null;
    }
    return FloatingActionButton(
      onPressed: null,
      child: Icon(Icons.add),
      tooltip: 'Cadastrar Cidade',
    );
  }

  @override
  void dispose() {
    _controllerResposta.dispose();
    super.dispose();
  }
}
