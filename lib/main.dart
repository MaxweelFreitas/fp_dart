import 'package:flat_buffers/flat_buffers.dart' as fb;

import 'pessoa_exemplo_generated.dart' as exemplo;

void main() {
  final builder = fb.Builder();

  // Cria o buffer com os dados
  exemplo.PessoaObjectBuilder pessoaBuilder = exemplo.PessoaObjectBuilder(
    nome: 'João',
    idade: 25,
  );

  final pessoaOffset = pessoaBuilder.finish(builder);

  builder.finish(pessoaOffset);

  final buffer = builder.buffer;

  // Agora vamos ler os dados de volta
  final pessoa = exemplo.Pessoa(buffer);

  print('Nome: ${pessoa.nome}');
  print('Idade: ${pessoa.idade}');
}
