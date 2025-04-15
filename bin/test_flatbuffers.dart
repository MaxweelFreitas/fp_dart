import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:fp_dart/pessoa_exemplo_generated.dart' as exemplo;

void main() {
  const total = 1000000;
  final random = Random();
  final stopwatch = Stopwatch()..start();

  final builder = fb.Builder(initialSize: 1024 * 1024 * 128); // 128MB

  final pessoas = <exemplo.PessoaObjectBuilder>[];

  for (int i = 0; i < total; i++) {
    pessoas.add(exemplo.PessoaObjectBuilder(
      nome: 'Pessoa_$i',
      idade: random.nextInt(100),
    ));
  }

  // Usa o ObjectBuilder gerado para a tabela wrapper
  final wrapper = exemplo.PessoasWrapperObjectBuilder(
    pessoas: pessoas,
  );

  final rootOffset = wrapper.finish(builder);
  builder.finish(rootOffset);

  final Uint8List data = builder.buffer.sublist(0, builder.offset);

  File('output_flatbuffers.bin').writeAsBytesSync(data);

  stopwatch.stop();
  print(
      '✅ FlatBuffers: Codificados $total pessoas em ${stopwatch.elapsedMilliseconds}ms');
  print('📦 Tamanho final do arquivo: ${data.lengthInBytes ~/ 1024} KB');
}
