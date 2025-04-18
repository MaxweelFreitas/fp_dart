// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:fp_dart/base/const.dart';
import 'package:fp_dart/pessoa_exemplo_generated.dart' as exemplo;

void main() {
  const iterations = 10;
  const totalPessoas = 1000000;

  print('\n📦$cyanBright Benchmark de Escrita');
  benchmarkJsonEscrita(iterations, totalPessoas);
  benchmarkFlatBuffersEscrita(iterations, totalPessoas);

  print('\n📥$cyanBright Benchmark de Leitura');
  benchmarkJsonLeitura(iterations);
  benchmarkFlatBuffersLeitura(iterations);

  print('\n📊$cyanBright Tamanho dos Arquivos Gerados');
  printFileSizes();
}

//
// ===== JSON =====
//

void benchmarkJsonEscrita(final int iterations, final int totalPessoas) {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final pessoas = List.generate(
      totalPessoas,
      (final j) => {
        'nome': 'Pessoa $j',
        'idade': 20 + (j % 100),
      },
    );

    final jsonMap = {'pessoas': pessoas};
    final jsonString = jsonEncode(jsonMap);

    File('output_json.json').writeAsStringSync(jsonString);

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  print(
    '✅ JSON: Média de escrita ($totalPessoas pessoas): $orange${totalTime / iterations}ms',
  );
}

void benchmarkJsonLeitura(final int iterations) {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final file = File('output_json.json');
    final jsonString = file.readAsStringSync();
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final List<dynamic> pessoas = decoded['pessoas'];

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  print('✅ JSON: Média de leitura: $orange${totalTime / iterations}ms');
}

//
// ===== FlatBuffers =====
//

void benchmarkFlatBuffersEscrita(final int iterations, final int totalPessoas) {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    // Criar o builder com um tamanho inicial maior para evitar alocações repetidas
    final builder = fb.Builder(initialSize: 1024 * 1024 * 64);

    // Criar os objetos de pessoa
    final pessoasObjBuilders = <exemplo.PessoaObjectBuilder>[];
    for (int j = 0; j < totalPessoas; j++) {
      pessoasObjBuilders.add(
        exemplo.PessoaObjectBuilder(
          nome: 'Pessoa $j',
          idade: 20 + (j % 100),
        ),
      );
    }

    // Adicionar as pessoas ao builder
    final pessoasOffset = builder.writeList(
      pessoasObjBuilders.map((final e) => e.finish(builder)).toList(),
    );

    // Criar o wrapper com as pessoas utilizando o builder
    builder.startTable(1);
    builder.addOffset(0, pessoasOffset);
    final offset = builder.endTable();

    // Finalizar o FlatBuffer (deve ser chamado antes de pegar os bytes)
    builder.finish(offset);

    // Usar sublist para pegar os bytes válidos do builder
    final Uint8List bytes = builder.buffer.sublist(0, builder.offset);

    // Escrever os bytes gerados no arquivo
    File('output_flatbuffers.bin').writeAsBytesSync(bytes);

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  print(
    '✅ FlatBuffers: Média de escrita ($totalPessoas pessoas): $orange${totalTime / iterations}ms',
  );
}

void benchmarkFlatBuffersLeitura(final int iterations) {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();

    final file = File('output_flatbuffers.bin');
    final bytes = file.readAsBytesSync();
    final wrapper = exemplo.PessoasWrapper(bytes);
    final total = wrapper.pessoas?.length ?? 0;

    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  print('✅ FlatBuffers: Média de leitura: $orange${totalTime / iterations}ms');
}

//
// ===== Tamanho dos arquivos =====
//

void printFileSizes() {
  final jsonFile = File('output_json.json');
  final fbFile = File('output_flatbuffers.bin');

  final jsonSize = jsonFile.existsSync() ? jsonFile.lengthSync() : 0;
  final fbSize = fbFile.existsSync() ? fbFile.lengthSync() : 0;

  print(
    '📁 JSON: ${jsonSize} bytes $orange(${(jsonSize / 1024).toStringAsFixed(2)} KB | ${(jsonSize / (1024 * 1024)).toStringAsFixed(2)} MB)',
  );
  print(
    '📁 FlatBuffers: ${fbSize} bytes $orange(${(fbSize / 1024).toStringAsFixed(2)} KB | ${(fbSize / (1024 * 1024)).toStringAsFixed(2)} MB)',
  );
}
