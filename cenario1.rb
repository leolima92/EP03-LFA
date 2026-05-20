require_relative 'mtu'
# Cenário 1: Linguagem Regular a*b*
# Estados:  fa = q0 (lendo a's), faa = q1 (lendo b's), fb = aceitação
# Símbolos: sc = a, scc = b

q0   = "fa"
q1   = "faa"
qacc = "fb"
a    = "sc"
b    = "scc"
branco = "_"
dir  = "d"

# Transições
d1 = "#{q0}#{a}#{q0}#{a}#{dir}"           # (fa, sc)  -> (fa, sc, d)
d2 = "#{q0}#{b}#{q1}#{b}#{dir}"           # (fa, scc) -> (faa, scc, d)
d3 = "#{q0}#{branco}#{qacc}#{branco}#{dir}" # (fa, _)   -> (fb, _, d)
d4 = "#{q1}#{b}#{q1}#{b}#{dir}"           # (faa, scc)-> (faa, scc, d)
d5 = "#{q1}#{branco}#{qacc}#{branco}#{dir}" # (faa, _)  -> (fb, _, d)

regras = "#{d1}#{d2}#{d3}#{d4}#{d5}"

# Cadeia: aabbb
cadeia = "#{a}#{a}#{b}#{b}#{b}"

entrada = regras + "#" + cadeia

mt = MTU.new
puts " Cenário 1: Linguagem Regular a*b*"
puts " Cadeia: aabbb"
puts ""
puts "Entrada: #{entrada}"
puts ""
puts "Decidiu? #{mt.processar(entrada)}"
puts "Fita: #{mt.fita}"