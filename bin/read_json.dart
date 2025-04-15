import 'dart:convert';
import 'dart:io';

void main() {
  final stopwatch = Stopwatch()..start();

  final file = File('output_json.json');
  final jsonString = file.readAsStringSync();

  final decoded = jsonDecode(jsonString);
  final pessoas = decoded['pessoas'] as List;

  stopwatch.stop();
  print(
      '✅ JSON: Lidos ${pessoas.length} pessoas em ${stopwatch.elapsedMilliseconds}ms');
}
