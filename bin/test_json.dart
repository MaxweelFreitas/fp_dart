import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  const total = 100000;
  final random = Random();
  final stopwatch = Stopwatch()..start();

  final pessoas = <Map<String, dynamic>>[];

  for (int i = 0; i < total; i++) {
    pessoas.add({
      'nome': 'Pessoa_$i',
      'idade': random.nextInt(100),
    });
  }

  final wrapper = {
    'pessoas': pessoas,
  };

  final jsonString = jsonEncode(wrapper);
  final bytes = utf8.encode(jsonString);

  File('output_json.json').writeAsBytesSync(bytes);

  stopwatch.stop();
  print(
      '✅ JSON: Codificados $total pessoas em ${stopwatch.elapsedMilliseconds}ms');
  print('📦 Tamanho final do arquivo: ${bytes.length ~/ 1024} KB');
}
