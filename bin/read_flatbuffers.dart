// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:fp_dart/pessoa_exemplo_generated.dart' as exemplo;

void main() {
  final stopwatch = Stopwatch()..start();

  final file = File('output_flatbuffers.bin');
  final bytes = file.readAsBytesSync();

  final wrapper = exemplo.PessoasWrapper(bytes);

  final total = wrapper.pessoas?.length ?? 0;
  for (int i = 0; i < total; i++) {
    final pessoa = wrapper.pessoas![i];
    final nome = pessoa.nome;
    final idade = pessoa.idade;
    // Aqui você pode usar os dados como quiser
    // print('$nome, $idade');
  }

  stopwatch.stop();
  print(
    '✅ FlatBuffers: Lidos $total pessoas em ${stopwatch.elapsedMilliseconds}ms',
  );
}
