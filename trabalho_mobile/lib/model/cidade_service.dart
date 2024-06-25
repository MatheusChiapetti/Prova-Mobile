import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../model/cidade.dart';

class CidadeService {
  static const _baseUrl = 'http://cloud.colegiomaterdei.com.br:8090/cidades';


  Future<void> saveCidade(Cidade cidade) async{
    final uri = Uri.parse(_baseUrl);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final body = cidade.toJson();
    final Response response = await post(uri, body: json.encode(body), headers: headers);
    if(response.statusCode != 200 || response.body.isEmpty){
      throw Exception();
    }
  }

  Future<void> deleteCidade(Cidade cidade) async {
    final uri = Uri.parse('$_baseUrl/${cidade.codigo}');
    Response response = await delete(uri);
    if(response.statusCode != 200) {
      throw Exception();
    }
  }

}