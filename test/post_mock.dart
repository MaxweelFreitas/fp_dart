import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fp_dart/base/buffer_utils.dart';
import 'package:fp_dart/base/const.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../lib/pessoa_exemplo_generated.dart' as exemplo;
import '../lib/user_usr_generated.dart' as usr;

void main() async {
  final dio = Dio();
  final adapter = DioAdapter(dio: dio);

  // ----- Enviar pessoa única -----
  final buffer = buildFlatBuffer(
    debug: true,
    validate: true,
    buildFn: (builder) {
      final pessoa = exemplo.PessoaObjectBuilder(nome: 'João', idade: 25);
      return pessoa.finish(builder);
    },
  );

  print('Buffer de Pessoa enviado: $buffer\n');

  // Mock da API
  adapter.onPost(
    '/api/pessoa',
    (server) => server.reply(200, buffer),
    data: buffer,
    headers: {'Content-Type': 'application/octet-stream'},
  );

  final response = await dio.post(
    '/api/pessoa',
    data: buffer,
    options: Options(
      headers: {'Content-Type': 'application/octet-stream'},
      responseType: ResponseType.bytes,
    ),
  );

  final Uint8List data = response.data;

  try {
    final pessoaRecebida = exemplo.Pessoa(data);
    print(
      'Pessoa recebida:\n$orange - nome: ${pessoaRecebida.nome}, idade: ${pessoaRecebida.idade}\n',
    );
  } on Exception catch (e) {
    print('Erro ao ler pessoa: $e');
  }

  // ----- Enviar lista de pessoas -----
  final pessoas = [
    exemplo.PessoaObjectBuilder(nome: 'João', idade: 25),
    exemplo.PessoaObjectBuilder(nome: 'Maria', idade: 30),
  ];

  final listaBuffer = buildFlatBuffer(
    initialSize: 512,
    buildFn: (builder) {
      final wrapper = exemplo.PessoasWrapperObjectBuilder(pessoas: pessoas);
      return wrapper.finish(builder);
    },
  );

  print('Buffer de Lista de Pessoas enviado: $listaBuffer\n');

  // Mock da resposta
  adapter.onPost(
    '/api/pessoas',
    (server) => server.reply(200, listaBuffer),
    data: listaBuffer,
    headers: {'Content-Type': 'application/octet-stream'},
  );

  final responseLista = await dio.post(
    '/api/pessoas',
    data: listaBuffer,
    options: Options(
      headers: {'Content-Type': 'application/octet-stream'},
      responseType: ResponseType.bytes,
    ),
  );

  final Uint8List dataPessoa = responseLista.data;

  final wrapperLido = exemplo.PessoasWrapper(dataPessoa);

  print('Lista de pessoas recebida:');
  for (final exemplo.Pessoa p in wrapperLido.pessoas ?? []) {
    print('$orange - nome: ${p.nome}, idade: ${p.idade}');
  }
}
