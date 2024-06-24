import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:usando_api/model/cep.dart';
import 'package:usando_api/services/cep_service.dart';

class ConsultaCepFragment extends StatefulWidget {
  static const title = 'Buscar CEP';
  @override
  State<StatefulWidget> createState() => _ConsultaCepFragmentState();
}

class _ConsultaCepFragmentState extends State<ConsultaCepFragment> {
  final _service = CepService();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _loading = false;
  final _cepFormat = MaskTextInputFormatter(
      mask: '######-###',
      filter: {'#' : RegExp('r[0-9]')}
  );
  Cep? _cep;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: 'CEP',
                  suffixIcon: _loading ? Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ) : IconButton(
                    onPressed: _findCep, icon: Icon(Icons.search),
                  )
              ),
              inputFormatters: [_cepFormat],
              validator: (String? value){
                if(value == null || value.isEmpty || !_cepFormat.isFill()){
                  return 'Informe um CEP válido';
                }
                return null;
              },
            ),
          ),
          Container(height: 10),
          ..._buildResultWidgets(),
        ],
      ),
    );
  }

  Future<void> _findCep() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    try{
      _cep = await _service.findCepAsObject(_cepFormat.getUnmaskedText());
    } catch(e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ocorreu um erro ao buscar o CEP. Tente novamente.')));
    }
  }

  List<Widget> _buildResultWidgets(){
    final List<Widget> widgets = [];
    if(_cep != null) {
      final map = _cep!.toJson();
      for(final key in map.keys){
        widgets.add(Text('$key: ${map[key]}'));
      }
    }
    return widgets;
  }

}