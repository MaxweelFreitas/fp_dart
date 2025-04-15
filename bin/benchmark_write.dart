import 'dart:io';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:fp_dart/pessoa_exemplo_generated.dart' as exemplo;

void main() {
  benchmarkFlatBuffersEscrita(10); // Faz 10 iterações e calcula a média
}

void benchmarkFlatBuffersEscrita(int iterations) {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    // ignore: unused_local_variable
    final builder = fb.Builder(initialSize: 1024 * 100);

    // Cria 1000 pessoas
    final pessoasObjBuilders = <exemplo.PessoaObjectBuilder>[];
    for (int j = 0; j < 1000; j++) {
      pessoasObjBuilders.add(exemplo.PessoaObjectBuilder(
        nome: 'Pessoa $j',
        idade: 20 + j,
      ));
    }

    // Monta o wrapper
    final wrapperBuilder = exemplo.PessoasWrapperObjectBuilder(
      pessoas: pessoasObjBuilders,
    );

    // Gera os bytes
    final bytes = wrapperBuilder.toBytes();

    // Salva o arquivo
    final file = File('output_flatbuffers_escrita.bin');
    file.writeAsBytesSync(bytes);

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  print(
      '✅ FlatBuffers Escrita (via ObjectBuilder): Média de escrita: ${totalTime / iterations}ms');
}
