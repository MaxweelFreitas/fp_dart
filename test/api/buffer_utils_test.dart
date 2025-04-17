import 'dart:typed_data';

import 'package:fp_dart/base/buffer_utils.dart';
import 'package:fp_dart/base/const.dart';
import 'package:test/test.dart';

import '../../lib/pessoa_exemplo_generated.dart' as exemplo;

void main() {
  group('$limeGreen FlatBuffer Utils →$reset', () {
    test('Cria e lê uma Pessoa com sucesso', () {
      final buffer = buildFlatBuffer(
        initialSize: 64,
        buildFn: (final builder) {
          final pessoa = exemplo.PessoaObjectBuilder(nome: 'João', idade: 42);
          return pessoa.finish(builder);
        },
      );

      final pessoaLida = readFlatBuffer<exemplo.Pessoa>(
        buffer,
        exemplo.Pessoa.new,
        debug: true,
      );

      expect(pessoaLida.nome, equals('João'));
      expect(pessoaLida.idade, equals(42));
    });

    test('Cria e lê múltiplas Pessoas em um wrapper', () {
      final pessoas = [
        exemplo.PessoaObjectBuilder(nome: 'Alice', idade: 30),
        exemplo.PessoaObjectBuilder(nome: 'Bob', idade: 35),
      ];

      final buffer = buildFlatBuffer(
        initialSize: 64,
        buildFn: (final builder) {
          final wrapper = exemplo.PessoasWrapperObjectBuilder(pessoas: pessoas);
          return wrapper.finish(builder);
        },
      );

      final wrapperLido = readFlatBuffer<exemplo.PessoasWrapper>(
        buffer,
        exemplo.PessoasWrapper.new,
        debug: true,
      );

      expect(wrapperLido.pessoas?.length, equals(2));
      expect(wrapperLido.pessoas?[0].nome, equals('Alice'));
      expect(wrapperLido.pessoas?[1].nome, equals('Bob'));
    });

    test('Falha ao criar com offset inválido', () {
      expect(
        () => buildFlatBuffer(
          validate: true,
          buildFn: (final _) => 0, // Offset inválido proposital
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Cria buffer com debug ativo (sem falhar)', () {
      final buffer = buildFlatBuffer(
        debug: true,
        buildFn: (final builder) {
          final pessoa = exemplo.PessoaObjectBuilder(nome: 'Debug', idade: 99);
          return pessoa.finish(builder);
        },
      );

      final pessoaLida = readFlatBuffer<exemplo.Pessoa>(
        buffer,
        exemplo.Pessoa.new,
        debug: true,
      );

      expect(pessoaLida.nome, equals('Debug'));
      expect(pessoaLida.idade, equals(99));
    });

    test('Cria buffer com tamanho inicial maior que o necessário', () {
      final buffer = buildFlatBuffer(
        initialSize: 1024,
        buildFn: (final builder) {
          final pessoa = exemplo.PessoaObjectBuilder(nome: 'Grande', idade: 1);
          return pessoa.finish(builder);
        },
      );

      final pessoaLida = readFlatBuffer<exemplo.Pessoa>(
        buffer,
        exemplo.Pessoa.new,
        debug: true,
      );

      expect(pessoaLida.nome, equals('Grande'));
      expect(pessoaLida.idade, equals(1));
    });

    test('Buffers com mesmos dados geram mesma saída', () {
      Uint8List createBuffer() => buildFlatBuffer(
            buildFn: (final builder) {
              final pessoa =
                  exemplo.PessoaObjectBuilder(nome: 'Igual', idade: 10);
              return pessoa.finish(builder);
            },
          );

      final buffer1 = createBuffer();
      final buffer2 = createBuffer();

      expect(buffer1, equals(buffer2));
    });

    test('Cria Pessoa com nome vazio e idade zero', () {
      final buffer = buildFlatBuffer(
        buildFn: (final builder) {
          final pessoa = exemplo.PessoaObjectBuilder(nome: '', idade: 0);
          return pessoa.finish(builder);
        },
      );

      final pessoaLida = readFlatBuffer<exemplo.Pessoa>(
        buffer,
        exemplo.Pessoa.new,
        debug: true,
      );

      expect(pessoaLida.nome, equals(''));
      expect(pessoaLida.idade, equals(0));
    });
  });
}
