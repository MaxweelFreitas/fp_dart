import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:fp_dart/base/const.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../lib/pessoa_exemplo_generated.dart' as exemplo;

void main() async {
  final dio = Dio();
  final adapter = DioAdapter(dio: dio);

  // ----- Enviar pessoa única -----
  final builder = fb.Builder(initialSize: 256);
  final pessoa = exemplo.PessoaObjectBuilder(nome: 'João', idade: 25);
  final pessoaOffset = pessoa.finish(builder);
  builder.finish(pessoaOffset); // Finaliza o buffer corretamente
  final Uint8List buffer = builder.buffer;

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

  final builder2 = fb.Builder(initialSize: 512);
  final wrapper = exemplo.PessoasWrapperObjectBuilder(pessoas: pessoas);
  final wrapperOffset = wrapper.finish(builder2);
  builder2.finish(wrapperOffset); // Finaliza o buffer corretamente
  final Uint8List listaBuffer = builder2.buffer;

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
