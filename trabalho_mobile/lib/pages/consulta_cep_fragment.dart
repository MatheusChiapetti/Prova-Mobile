import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ConsultaCepFragment extends StatefulWidget {
  static const title = 'Buscar CEP';
  @override
  State<StatefulWidget> createState() => _ConsultaCepFragmentState();
}

class _ConsultaCepFragmentState extends State<ConsultaCepFragment> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _loading = false;
  final _cepFormat = MaskTextInputFormatter(
      mask: '######-###',
      filter: {'#' : RegExp('r[0-9]')}
  );
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
                    onPressed: null, icon: Icon(Icons.search),
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
        ],
      ),
    );
  }


}