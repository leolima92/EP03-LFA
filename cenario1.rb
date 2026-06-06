require_relative 'mtu'

# Cenário 1: MT que reconhece a Linguagem Regular a*b*
#
# A máquina e a cadeia de entrada ficam em arquivos separados:
# - cenarios/cenario1_maquina.txt  -> contém somente as transições codificadas da MT
# - cenarios/cenario1_entrada.txt  -> contém somente a cadeia de entrada codificada
#
# O programa junta os dois no formato esperado pela MTU:
# C(M)#w

arquivo_maquina = File.join(__dir__, "cenarios", "cenario1_maquina.txt")
arquivo_entrada = File.join(__dir__, "cenarios", "cenario1_entrada.txt")

maquina = File.read(arquivo_maquina).strip
cadeia = File.read(arquivo_entrada).strip

entrada = maquina + "#" + cadeia

mt = MTU.new

puts "=========================================="
puts " Cenário 1: Linguagem Regular a*b*"
puts " Máquina: cenarios/cenario1_maquina.txt"
puts " Entrada: cenarios/cenario1_entrada.txt"
puts "=========================================="
puts ""
puts "Código da máquina: #{maquina}"
puts "Cadeia de entrada: #{cadeia}"
puts ""
puts "Entrada completa da MTU: #{entrada}"
puts ""
puts "Decidiu? #{mt.processar(entrada)}"
puts "Fita: #{mt.fita}"