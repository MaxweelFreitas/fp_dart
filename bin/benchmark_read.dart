import 'dart:convert';
import 'dart:io';

import 'package:fp_dart/pessoa_exemplo_generated.dart' as exemplo;

void benchmarkJson(int iterations) {
  final stopwatch = Stopwatch();
  int totalTime = 0;

  for (int i = 0; i < iterations; i++) {
    stopwatch.start();
    final file = File('output_json.json');
    final jsonString = file.readAsStringSync();
    final decoded = jsonDecode(jsonString);
    final pessoas = decoded['pessoas'] as List;
    stopwatch.stop();
    totalTime += stopwatch.elapsedMilliseconds;
    stopwatch.reset();
  }

  print('✅ JSON: Média de leitura de pessoas: ${totalTime / iterations}ms');
}

void benchmarkFlatBuffers(int iterations) {
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

  print(
      '✅ FlatBuffers: Média de leitura de pessoas: ${totalTime / iterations}ms');
}

void main() {
  const iterations = 10; // Número de iterações para o benchmark
  benchmarkJson(iterations);
  benchmarkFlatBuffers(iterations);
}
