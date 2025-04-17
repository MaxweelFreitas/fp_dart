/// Utilitário para leitura e escrita de buffers FlatBuffers de forma genérica.
///
/// Este arquivo fornece funções reutilizáveis para construir (`buildFlatBuffer`)
/// e ler (`readFlatBuffer`) buffers usando FlatBuffers em Dart.
///
/// Você pode ativar logs e validação com as flags `debug` e `validate`.
///
/// ### Exemplo de uso com `PessoaObjectBuilder`
/// ```dart
/// import 'buffer_utils.dart';
/// import 'exemplo_generated.dart' as exemplo;
///
/// // Construção do buffer
/// final buffer = buildFlatBuffer(
///   initialSize: 256,
///   debug: true,
///   validate: true,
///   buildFn: (builder) {
///     final pessoa = exemplo.PessoaObjectBuilder(nome: 'João', idade: 25);
///     return pessoa.finish(builder);
///   },
/// );
///
/// // Leitura do buffer
/// final pessoaLida = readFlatBuffer<exemplo.Pessoa>(
///   buffer: buffer,
///   debug: true,
///   validate: true,
///   readerFn: exemplo.Pessoa.read,
/// );
///
/// print('Nome: ${pessoaLida.nome}');
/// print('Idade: ${pessoaLida.idade}');
/// ```
///
/// ### Exemplo com lista (`PessoasWrapperObjectBuilder`)
/// ```dart
/// final pessoas = [
///   exemplo.PessoaObjectBuilder(nome: 'João', idade: 25),
///   exemplo.PessoaObjectBuilder(nome: 'Maria', idade: 30),
/// ];
///
/// final bufferLista = buildFlatBuffer(
///   initialSize: 512,
///   debug: true,
///   validate: true,
///   buildFn: (builder) {
///     final wrapper = exemplo.PessoasWrapperObjectBuilder(pessoas: pessoas);
///     return wrapper.finish(builder);
///   },
/// );
///
/// final wrapperLido = readFlatBuffer<exemplo.PessoasWrapper>(
///   buffer: bufferLista,
///   debug: true,
///   validate: true,
///   readerFn: exemplo.PessoasWrapper.read,
/// );
///
/// for (final p in wrapperLido.pessoas ?? []) {
///   print('Nome: ${p.nome}, Idade: ${p.idade}');
/// }
/// ```
library buffer_utils;

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;

import 'const.dart';

/// Constrói um buffer FlatBuffer de forma genérica.
///
/// - [initialSize]: tamanho inicial do buffer (ex: 256, 512).
/// - [buildFn]: função que recebe o builder e retorna o offset do objeto.
/// - [debug]: se `true`, imprime logs de criação.
/// - [validate]: se `true`, verifica se o offset é válido.
Uint8List buildFlatBuffer({
  final int initialSize = 256,
  required final int Function(fb.Builder builder) buildFn,
  final bool debug = false,
  final bool validate = false,
}) {
  final builder = fb.Builder(initialSize: initialSize);

  if (debug) {
    print(
      '$orange[FlatBuffer] Inicializando builder com $initialSize bytes...',
    );
  }

  final offset = buildFn(builder);

  if (validate && offset <= 0) {
    throw Exception('$orange[FlatBuffer] Offset inválido: $offset');
  }

  builder.finish(offset);

  if (debug) {
    print('$orange[FlatBuffer] Buffer finalizado com offset: $offset');
    print(
      '$orange[FlatBuffer] Tamanho final do buffer: ${builder.buffer.lengthInBytes} bytes',
    );
  }

  return builder.buffer;
}

/// Lê um buffer FlatBuffer de forma genérica.
///
/// - [buffer]: o `Uint8List` contendo os dados.
/// - [readerFn]: função que lê a raiz do objeto no buffer.
/// - [debug]: se `true`, imprime logs de leitura.
/// - [validate]: se `true`, valida o offset do objeto.
T readFlatBuffer<T>({
  required final Uint8List buffer,
  required final T Function(fb.BufferContext bc, int offset) readerFn,
  final bool debug = false,
  final bool validate = false,
}) {
  if (debug) {
    print('$orange[FlatBuffer] Iniciando leitura do buffer...');
    print(
      '$orange[FlatBuffer] Tamanho do buffer: ${buffer.lengthInBytes} bytes',
    );
  }

  final bc = fb.BufferContext.fromBytes(buffer);
  final rootOffset = bc.derefObject(0);

  if (validate && rootOffset <= 0) {
    throw Exception('$orange[FlatBuffer] Offset raiz inválido: $rootOffset');
  }

  final result = readerFn(bc, rootOffset);

  if (debug) print('$orange[FlatBuffer] Leitura concluída com sucesso.');

  return result;
}
