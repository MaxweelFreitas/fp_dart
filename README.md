# Benchmark de Performance entre JSON e FlatBuffers

Este projeto realiza benchmarks para comparar o desempenho de **JSON** e **FlatBuffers** em termos de **escrita** e **leitura** de grandes quantidades de dados. A comparação foca especialmente em duas operações: o tempo necessário para gravar e ler dados de arquivos, além do tamanho dos arquivos gerados.

## Objetivo

O principal objetivo deste código é avaliar como o **JSON** e o **FlatBuffers** se comportam em termos de desempenho quando lidam com grandes volumes de dados, simulando um cenário onde há um número considerável de pessoas armazenadas em uma estrutura de dados. Cada pessoa contém um nome e uma idade.

A comparação é feita nos seguintes critérios:

- **Tempo de Escrita**: Quanto tempo cada formato leva para gravar um grande número de registros (pessoas) em um arquivo.
- **Tempo de Leitura**: Quanto tempo é necessário para ler os arquivos e processar os dados.
- **Tamanho do Arquivo**: O tamanho do arquivo gerado em cada formato.

## Estrutura do Código

O código realiza os seguintes testes:

1. **JSON**:
   - Cria uma lista de pessoas com atributos `nome` e `idade`.
   - Serializa essa lista para JSON e grava em um arquivo (`output_json.json`).
   - Lê o arquivo JSON e decodifica os dados.

2. **FlatBuffers**:
   - Cria uma lista de objetos `Pessoa` e os serializa utilizando a biblioteca **FlatBuffers**.
   - Grava os dados no formato binário (`output_flatbuffers.bin`).
   - Lê os dados do arquivo binário e processa as informações.

## Como Usar

1. **Instalar Dependências**

Certifique-se de ter o **Dart** instalado em seu sistema. Para instalar o Dart, siga a [documentação oficial](https://dart.dev/get-dart).

2. **Instalar Pacotes**

Antes de rodar o código, é necessário instalar as dependências do projeto. No terminal, navegue até a pasta do projeto e execute:

```bash
dart pub get
```

3. **Rodar os Benchmarks**

Execute o código para começar o benchmark. O código irá realizar os testes de leitura e escrita para ambos os formatos e imprimir o tempo médio de execução para cada operação.

```bash
dart run read_write.dart
```

4. **Resultado Esperado**

O terminal irá exibir os seguintes resultados:

- **Média de Tempo de Escrita**: O tempo médio necessário para gravar o arquivo para ambos os formatos (JSON e FlatBuffers).
- **Média de Tempo de Leitura**: O tempo médio necessário para ler o arquivo e processar os dados.
- **Tamanho do Arquivo**: O tamanho dos arquivos gerados (`output_json.json` e `output_flatbuffers.bin`) em bytes e MB.

## Exemplo de Saída

```bash
📦 Benchmark de Escrita
✅ JSON: Média de escrita (1000000 pessoas): 928.2ms
✅ FlatBuffers: Média de escrita (1000000 pessoas): 475.1ms

📥 Benchmark de Leitura
✅ JSON: Média de leitura: 695.3ms
✅ FlatBuffers: Média de leitura: 19.7ms

📊 Tamanho dos Arquivos Gerados
📁 JSON: 36088903 bytes (35243.07 KB | 34.42 MB)
📁 FlatBuffers: 43960024 bytes (42929.71 KB | 41.92 MB)
```

## Conclusão

Este benchmark permite comparar a performance de **JSON** e **FlatBuffers** para a manipulação de grandes volumes de dados. O **FlatBuffers** tende a ser mais eficiente em termos de tempo de leitura e tamanho do arquivo, enquanto o **JSON** é mais simples de trabalhar e pode ser preferível em certos cenários.

## Licença

Este projeto é de código aberto e está sob a [Licença MIT](LICENSE).

---

Esse `README.md` apresenta de forma clara o objetivo, a configuração e os resultados esperados do código, além de fornecer instruções sobre como executar os benchmarks.