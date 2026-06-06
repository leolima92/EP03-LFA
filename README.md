# Máquina de Turing Universal

Este projeto implementa uma **Máquina de Turing Universal (MTU)** em Ruby, desenvolvida para a disciplina de Linguagens Formais e Autômatos.

A proposta do trabalho é construir uma máquina capaz de receber como entrada a codificação de outra Máquina de Turing `M`, junto com uma cadeia `w`, e simular o processamento dessa máquina sobre a cadeia informada.

A entrada geral da MTU segue o formato:

```txt
C(M)#w
```

Onde:

* `C(M)` representa a codificação da Máquina de Turing que será simulada;
* `#` é o separador entre a máquina e a cadeia de entrada;
* `w` é a cadeia que será processada pela máquina simulada.

---

## Objetivo do projeto

O objetivo principal é implementar uma Máquina de Turing Universal que leia uma máquina codificada, interprete suas transições e execute a simulação sobre uma fita de trabalho.

Para validar a implementação, foram criados três cenários de teste:

1. Uma MT que reconhece a linguagem regular `a*b*`;
2. Uma MT que reconhece a linguagem livre de contexto `a^n b^n`;
3. Uma MT que reconhece a linguagem sensível ao contexto `a^n b^n c^n`.

Cada cenário possui a máquina codificada e a cadeia de entrada em arquivos separados, conforme solicitado no enunciado.

---

## Codificação utilizada

A codificação segue o padrão definido para o trabalho.

| Elemento                          | Codificação              |
| --------------------------------- | ------------------------ |
| Estados internos de não aceitação | `fa`, `faa`, `faaa`, ... |
| Estados de aceitação              | `fb`, `fbb`, `fbbb`, ... |
| Símbolos da fita                  | `sc`, `scc`, `sccc`, ... |
| Movimento para a direita          | `d`                      |
| Movimento para a esquerda         | `e`                      |
| Símbolo branco                    | `_`                      |
| Separador entre máquina e entrada | `#`                      |

Exemplo de transição:

```txt
(fa, sc) -> (faa, sccc, d)
```

Essa transição significa:

* estando no estado `fa`;
* lendo o símbolo `sc`;
* a máquina vai para o estado `faa`;
* escreve `sccc`;
* move o cursor para a direita.

Na codificação final, essa transição é representada de forma contínua:

```txt
fascfaascccd
```

---

## Estrutura do projeto

```txt
EP03-LFA/
│
├── mtu.rb
├── cenario1.rb
├── cenario2.rb
├── cenario3.rb
│
└── cenarios/
    ├── cenario1_maquina.txt
    ├── cenario1_entrada.txt
    ├── cenario2_maquina.txt
    ├── cenario2_entrada.txt
    ├── cenario3_maquina.txt
    └── cenario3_entrada.txt
```

---

## Arquivos principais

### `mtu.rb`

Contém a implementação da Máquina de Turing Universal.

Esse arquivo é responsável por:

* ler a entrada no formato `C(M)#w`;
* identificar e separar as transições da máquina codificada;
* ler a cadeia de entrada;
* montar a fita de trabalho;
* simular a execução da máquina;
* informar se a cadeia foi aceita ou rejeitada.

As transições são lidas e armazenadas como uma sequência simples, sendo percorridas uma a uma durante a simulação. A busca da transição aplicável é feita comparando o estado atual e o símbolo lido no momento, respeitando a ideia de execução por transições de estado.

---

### `cenario1.rb`

Executa o primeiro cenário de teste.

Linguagem reconhecida:

```txt
a*b*
```

Essa linguagem aceita cadeias formadas por zero ou mais símbolos `a`, seguidos por zero ou mais símbolos `b`.

Exemplos de cadeias pertencentes à linguagem:

```txt
ab
aabb
aaabbb
bbb
aaa
```

Exemplo de cadeia que não pertence:

```txt
aba
```

Arquivos utilizados:

```txt
cenarios/cenario1_maquina.txt
cenarios/cenario1_entrada.txt
```

---

### `cenario2.rb`

Executa o segundo cenário de teste.

Linguagem reconhecida:

```txt
a^n b^n
```

Essa linguagem aceita cadeias com a mesma quantidade de símbolos `a` e `b`, sempre com todos os `a` antes dos `b`.

Exemplos de cadeias pertencentes à linguagem:

```txt
ab
aabb
aaabbb
```

Exemplos de cadeias que não pertencem:

```txt
aab
abb
abab
```

Arquivos utilizados:

```txt
cenarios/cenario2_maquina.txt
cenarios/cenario2_entrada.txt
```

---

### `cenario3.rb`

Executa o terceiro cenário de teste.

Linguagem reconhecida:

```txt
a^n b^n c^n
```

Essa linguagem aceita cadeias com a mesma quantidade de símbolos `a`, `b` e `c`, respeitando a ordem: primeiro todos os `a`, depois todos os `b` e por fim todos os `c`.

Exemplos de cadeias pertencentes à linguagem:

```txt
abc
aabbcc
aaabbbccc
```

Exemplos de cadeias que não pertencem:

```txt
aabc
abbc
aabbc
abcc
```

Arquivos utilizados:

```txt
cenarios/cenario3_maquina.txt
cenarios/cenario3_entrada.txt
```

---

## Cenário 1: linguagem regular `a*b*`

### Entrada aceita testada

Cadeia original:

```txt
aabb
```

Cadeia codificada:

```txt
scscsccscc
```

Resultado obtido:

```txt
>>> ACEITA! Estado final: fb <<<
Decidiu? true
```

### Entrada rejeitada testada

Cadeia original:

```txt
aba
```

Cadeia codificada:

```txt
scsccsc
```

Resultado obtido:

```txt
>>> REJEITA! Estado: faa <<<
Decidiu? false
```

---

## Cenário 2: linguagem livre de contexto `a^n b^n`

### Entrada aceita testada

Cadeia original:

```txt
aabb
```

Cadeia codificada:

```txt
scscsccscc
```

Resultado obtido:

```txt
>>> ACEITA! Estado final: fb <<<
Decidiu? true
```

### Entrada rejeitada testada

Cadeia original:

```txt
aab
```

Cadeia codificada:

```txt
scscscc
```

Resultado obtido:

```txt
>>> REJEITA! Estado: faa <<<
Decidiu? false
```

---

## Cenário 3: linguagem sensível ao contexto `a^n b^n c^n`

### Entrada aceita testada

Cadeia original:

```txt
aabbcc
```

Cadeia codificada:

```txt
scscsccsccscccsccc
```

Resultado obtido:

```txt
>>> ACEITA! Estado final: fb <<<
Decidiu? true
```

### Entrada rejeitada testada

Cadeia original:

```txt
aabc
```

Cadeia codificada:

```txt
scscsccsccc
```

Resultado obtido:

```txt
>>> REJEITA! Estado: faa <<<
Decidiu? false
```

---

## Como executar

Dentro da pasta do projeto, execute os comandos abaixo.

### Executar cenário 1

```bash
ruby cenario1.rb
```

### Executar cenário 2

```bash
ruby cenario2.rb
```

### Executar cenário 3

```bash
ruby cenario3.rb
```

---

## Formato dos arquivos de entrada

Cada cenário possui dois arquivos principais dentro da pasta `cenarios`.

O arquivo com sufixo `_maquina.txt` contém somente a Máquina de Turing codificada:

```txt
cenario1_maquina.txt
cenario2_maquina.txt
cenario3_maquina.txt
```

O arquivo com sufixo `_entrada.txt` contém somente a cadeia de entrada codificada:

```txt
cenario1_entrada.txt
cenario2_entrada.txt
cenario3_entrada.txt
```

No momento da execução, o arquivo `.rb` de cada cenário lê os dois arquivos separadamente e monta a entrada final da MTU no formato:

```txt
C(M)#w
```

Essa separação foi feita para manter a estrutura mais próxima da proposta do trabalho e facilitar os testes com diferentes cadeias.

---

## Resultado esperado

Durante a execução, o programa mostra:

* as transições lidas da máquina codificada;
* a quantidade total de transições;
* a fita de símbolos montada a partir da entrada;
* cada passo executado pela máquina simulada;
* o resultado final, indicando se a cadeia foi aceita ou rejeitada.

Exemplo de aceite:

```txt
>>> ACEITA! Estado final: fb <<<
Decidiu? true
```

Exemplo de rejeição:

```txt
>>> REJEITA! Estado: faa <<<
Decidiu? false
```

---

## Considerações finais

O projeto implementa a leitura e simulação de uma Máquina de Turing codificada, seguindo o formato definido no enunciado.

A MTU não recebe diretamente uma linguagem pronta. Ela recebe uma máquina codificada e uma cadeia de entrada, separadas por `#`, e então simula a execução dessa máquina sobre a cadeia.

Foram implementados e testados três níveis de linguagens:

* linguagem regular;
* linguagem livre de contexto;
* linguagem sensível ao contexto.

Com isso, a implementação demonstra o funcionamento da Máquina de Turing Universal em diferentes cenários de reconhecimento.
