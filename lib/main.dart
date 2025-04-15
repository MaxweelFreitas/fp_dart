import 'package:flat_buffers/flat_buffers.dart' as fb;

import 'pessoa_exemplo_generated.dart' as exemplo;
import 'user_user.schema_generated.dart' as usr;

void main() {
  final builder = fb.Builder(initialSize: 1024);
  final builderUsr = fb.Builder(initialSize: 1024);

  // Cria o buffer com os dados
  exemplo.PessoaObjectBuilder pessoaBuilder = exemplo.PessoaObjectBuilder(
    nome: 'João',
    idade: 25,
  );

  usr.UserObjectBuilder userBuilder = usr.UserObjectBuilder(
    id: 10,
    name: 'Max',
    email: 'max@nZest.co',
  );

  final pessoaOffset = pessoaBuilder.finish(builder);
  final userOffset = userBuilder.finish(builderUsr);
  builder.finish(pessoaOffset);
  builderUsr.finish(userOffset);

  final buffer = builder.buffer;
  final bufferUsr = builderUsr.buffer;

  // Agora vamos ler os dados de volta
  final pessoa = exemplo.Pessoa(buffer);
  final user = usr.User(bufferUsr);

  print('Nome: ${pessoa.nome}');
  print('Idade: ${pessoa.idade}');
  print('=======User=======');
  print('ID: ${user.id}');
  print('Nome: ${user.name}');
  print('Email: ${user.email}');
}
