import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../lib/pessoa_exemplo_generated.dart' as exemplo;

void main() async {
  final dio = Dio();
  final adapter = DioAdapter(dio: dio);

  // Criação do buffer de uma Pessoa
  final builder = fb.Builder();
  final pessoa = exemplo.PessoaObjectBuilder(nome: 'João', idade: 25);
  final pessoaOffset = pessoa.finish(builder);
  builder.finish(pessoaOffset);
  final Uint8List buffer = builder.buffer;

  print('Buffer de Pessoa enviado: $buffer'); // Verificando o buffer enviado

  // Mockando a resposta da API
  adapter.onPost(
    '/api/pessoa',
    (server) => server.reply(200, buffer),
    data: buffer,
    headers: {'Content-Type': 'application/octet-stream'},
  );

  // Enviando buffer como POST com Content-Type binário
  final response = await dio.post(
    '/api/pessoa',
    data: buffer,
    options: Options(
      headers: {'Content-Type': 'application/octet-stream'},
      responseType: ResponseType.bytes,
    ),
  );

  // Verificando o buffer retornado
  final data = response.data as Uint8List;
  print('Buffer recebido: $data');

  // Lendo o buffer de volta para um objeto Pessoa
  final context = fb.BufferContext.fromBytes(data);

  try {
    final pessoaRecebida =
        exemplo.Pessoa.reader.read(context, context.derefObject(0));

    print(
        'Pessoa recebida: nome=${pessoaRecebida.nome}, idade=${pessoaRecebida.idade}');
  } catch (e) {
    print('Erro ao ler o buffer para o objeto Pessoa: $e');
  }

  // Agora um exemplo com lista de pessoas
  final pessoas = [
    exemplo.PessoaObjectBuilder(nome: 'João', idade: 25),
    exemplo.PessoaObjectBuilder(nome: 'Maria', idade: 30),
  ];

  final builder2 = fb.Builder();
  final wrapper = exemplo.PessoasWrapperObjectBuilder(pessoas: pessoas);
  final wrapperOffset = wrapper.finish(builder2);
  builder2.finish(wrapperOffset);
  final Uint8List listaBuffer = builder2.buffer;

  print(
      'Buffer de Lista de Pessoas enviado: $listaBuffer'); // Verificando o buffer de lista

  // Mockando resposta para lista de pessoas
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

  // Verificando o buffer retornado da lista de pessoas
  final contextLista = fb.BufferContext.fromBytes(responseLista.data);

  try {
    final pessoasWrapper = exemplo.PessoasWrapper.reader
        .read(contextLista, contextLista.derefObject(0));

    print('Lista de pessoas recebida:');
    for (exemplo.Pessoa p in pessoasWrapper.pessoas ?? []) {
      print(' - ${p.nome}, idade: ${p.idade}');
    }
  } catch (e) {
    print('Erro ao ler o buffer para a lista de pessoas: $e');
  }
}
