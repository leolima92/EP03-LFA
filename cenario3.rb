require_relative 'mtu'

# Cenário 3: MT que reconhece a Linguagem Sensível ao Contexto a^n b^n c^n
#
# A máquina e a cadeia de entrada ficam em arquivos separados:
# - cenarios/cenario3_maquina.txt
# - cenarios/cenario3_entrada.txt
#
# O programa junta os dois no formato:
# C(M)#w

arquivo_maquina = File.join(__dir__, "cenarios", "cenario3_maquina.txt")
arquivo_entrada = File.join(__dir__, "cenarios", "cenario3_entrada.txt")

maquina = File.read(arquivo_maquina).strip
cadeia = File.read(arquivo_entrada).strip

entrada = maquina + "#" + cadeia

mt = MTU.new

puts "=========================================="
puts " Cenário 3: Linguagem Sensível ao Contexto a^n b^n c^n"
puts " Máquina: cenarios/cenario3_maquina.txt"
puts " Entrada: cenarios/cenario3_entrada.txt"
puts "=========================================="
puts ""
puts "Código da máquina: #{maquina}"
puts "Cadeia de entrada: #{cadeia}"
puts ""
puts "Entrada completa da MTU: #{entrada}"
puts ""
puts "Decidiu? #{mt.processar(entrada)}"
puts "Fita: #{mt.fita}"

#Cenário certo: scscsccscc
#Cenário errado: scsccsc