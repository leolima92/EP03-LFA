require_relative 'mtu'
# Cenário 2: Linguagem Livre de Contexto a^n b^n
# Estratégia: marca a com X, b com Y, repete até marcar todos.
# Estados:  fa = q0, faa = q1, faaa = q2, fb = aceitação
# Símbolos: sc = a, scc = b, sccc = X, scccc = Y

q0   = "fa"
q1   = "faa"
q2   = "faaa"
qacc = "fb"
a    = "sc"
b    = "scc"
x    = "sccc"
y    = "scccc"
branco = "_"
dir  = "d"
esq  = "e"

# Transições
d1  = "#{q0}#{a}#{q1}#{x}#{dir}"            # marca a com X, busca b
d2  = "#{q0}#{x}#{q0}#{x}#{dir}"            # pula X
d3  = "#{q0}#{y}#{q0}#{y}#{dir}"            # pula Y
d4  = "#{q0}#{branco}#{qacc}#{branco}#{dir}" # tudo marcado, aceita
d5  = "#{q1}#{a}#{q1}#{a}#{dir}"            # pula a's
d6  = "#{q1}#{b}#{q2}#{y}#{esq}"            # marca b com Y, volta
d7  = "#{q1}#{y}#{q1}#{y}#{dir}"            # pula Y
d8  = "#{q2}#{a}#{q2}#{a}#{esq}"            # volta
d9  = "#{q2}#{x}#{q0}#{x}#{dir}"            # encontrou X, recomeça
d10 = "#{q2}#{y}#{q2}#{y}#{esq}"            # volta

regras = "#{d1}#{d2}#{d3}#{d4}#{d5}#{d6}#{d7}#{d8}#{d9}#{d10}"

# Cadeia: aabb
cadeia = "#{a}#{a}#{b}#{b}"

entrada = regras + "#" + cadeia

mt = MTU.new
puts "=========================================="
puts " Cenário 2: LLC a^n b^n"
puts " Cadeia: aabb"
puts "=========================================="
puts ""
puts "Entrada: #{entrada}"
puts ""
puts "Decidiu? #{mt.processar(entrada)}"
puts "Fita: #{mt.fita}"