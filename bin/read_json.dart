import 'dart:convert';
import 'dart:io';

void main() {
  final stopwatch = Stopwatch()..start();

  final file = File('output_json.json');
  final jsonString = file.readAsStringSync();

  final Map<String, dynamic> decoded = jsonDecode(jsonString);
  final List<dynamic> pessoas = decoded['pessoas'];
  print(pessoas.runtimeType);

  stopwatch.stop();
  print(
    '✅ JSON: Lidos ${pessoas.length} pessoas em ${stopwatch.elapsedMilliseconds}ms',
  );
}
