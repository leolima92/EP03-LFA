require_relative 'mtu'

# Cenário 1: MT para a^n b^n, conforme pedido no enunciado
# Estratégia:
# 1. Marca o primeiro a não processado com X.
# 2. Anda para a direita procurando um b não processado.
# 3. Marca esse b com Y.
# 4. Volta para a esquerda até encontrar X.
# 5. Repete o processo.
# 6. Quando todos os a's e b's estiverem marcados, aceita.
#
# Estados:
# fa   = q0: procura um a ainda não marcado
# faa  = q1: procura um b para casar com o a marcado
# faaa = q2: volta para o começo da fita
# fb   = qaceita
#
# Símbolos:
# sc    = a
# scc   = b
# sccc  = X, marcação de a
# scccc = Y, marcação de b

q0   = "fa"
q1   = "faa"
q2   = "faaa"
qacc = "fb"

# Símbolos da fita
a      = "sc"
b      = "scc"
x      = "sccc"
y      = "scccc"
branco = "_"

# Movimentos
dir = "d"
esq = "e"

# Transições da máquina M codificada
# q0: procura o próximo a não marcado
d1 = "#{q0}#{a}#{q1}#{x}#{dir}"              # (q0, a) -> (q1, X, D)
d2 = "#{q0}#{x}#{q0}#{x}#{dir}"              # (q0, X) -> (q0, X, D)
d3 = "#{q0}#{y}#{q0}#{y}#{dir}"              # (q0, Y) -> (q0, Y, D)
d4 = "#{q0}#{branco}#{qacc}#{branco}#{dir}"  # (q0, _) -> aceita

# q1: depois de marcar um a, procura um b correspondente
d5 = "#{q1}#{a}#{q1}#{a}#{dir}"              # (q1, a) -> (q1, a, D)
d6 = "#{q1}#{y}#{q1}#{y}#{dir}"              # (q1, Y) -> (q1, Y, D)
d7 = "#{q1}#{b}#{q2}#{y}#{esq}"              # (q1, b) -> (q2, Y, E)

# q2: volta para a esquerda até encontrar a marcação X
d8  = "#{q2}#{a}#{q2}#{a}#{esq}"             # (q2, a) -> (q2, a, E)
d9  = "#{q2}#{y}#{q2}#{y}#{esq}"             # (q2, Y) -> (q2, Y, E)
d10 = "#{q2}#{x}#{q0}#{x}#{dir}"             # (q2, X) -> (q0, X, D)

regras = "#{d1}#{d2}#{d3}#{d4}#{d5}#{d6}#{d7}#{d8}#{d9}#{d10}"

# Cadeia de teste: aabb
cadeia = "#{a}#{a}#{b}#{b}"

entrada = regras + "#" + cadeia

mt = MTU.new

puts "=========================================="
puts " Cenário 1: MT para a^n b^n"
puts " Cadeia: aabb"
puts "=========================================="
puts ""
puts "Entrada: #{entrada}"
puts ""
puts "Decidiu? #{mt.processar(entrada)}"
puts "Fita: #{mt.fita}"
