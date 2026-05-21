class MTU
  attr_accessor :fita, :estado, :cursor

  def initialize
    @estado = :qi
    @cursor = 0
  end

  def processar(entrada)
    @fita = "#" + entrada + " " * entrada.size * 3
    estado_leitura = ""
    simbolo_leitura = ""
    estado_destino = ""
    simbolo_escrita = ""
    movimento = "d"
    transicoes = []
    @fita_cadeia = []

    while true
      case [@estado, @fita[@cursor]]

      # === INÍCIO: lê '#' e vai pro primeiro token ===
      in [:qi, "#"]
        operar("#", :le_estado_atual, :D)

      # === LEITURA DO ESTADO ATUAL ===
      # Estado começa com 'f', seguido de 'a's ou 'b's
      in [:le_estado_atual, "f"]
        estado_leitura = "f"
        operar("f", :le_estado_atual_corpo, :D)
      in [:le_estado_atual_corpo, "a"]
        estado_leitura << "a"
        operar("a", :le_estado_atual_corpo, :D)
      in [:le_estado_atual_corpo, "b"]
        estado_leitura << "b"
        operar("b", :le_estado_atual_corpo, :D)

      # === LEITURA DO SÍMBOLO DE LEITURA ===
      # Símbolo começa com 's', seguido de 'c's
      # OU é '_' (branco)
      in [:le_estado_atual_corpo, "s"]
        simbolo_leitura = "s"
        operar("s", :le_simbolo_leitura_corpo, :D)
      in [:le_simbolo_leitura_corpo, "c"]
        simbolo_leitura << "c"
        operar("c", :le_simbolo_leitura_corpo, :D)
      in [:le_estado_atual_corpo, "_"]
        simbolo_leitura = "_"
        operar("_", :le_simbolo_leitura_fim, :D)

      # === LEITURA DO ESTADO DESTINO ===
      # Após ler o símbolo, o próximo 'f' indica estado destino
      in [:le_simbolo_leitura_corpo, "f"] | [:le_simbolo_leitura_fim, "f"]
        estado_destino = "f"
        operar("f", :le_estado_destino_corpo, :D)
      in [:le_estado_destino_corpo, "a"]
        estado_destino << "a"
        operar("a", :le_estado_destino_corpo, :D)
      in [:le_estado_destino_corpo, "b"]
        estado_destino << "b"
        operar("b", :le_estado_destino_corpo, :D)

      # === LEITURA DO SÍMBOLO DE ESCRITA ===
      in [:le_estado_destino_corpo, "s"]
        simbolo_escrita = "s"
        operar("s", :le_simbolo_escrita_corpo, :D)
      in [:le_simbolo_escrita_corpo, "c"]
        simbolo_escrita << "c"
        operar("c", :le_simbolo_escrita_corpo, :D)
      in [:le_estado_destino_corpo, "_"]
        simbolo_escrita = "_"
        operar("_", :le_simbolo_escrita_fim, :D)

      # === LEITURA DO MOVIMENTO ===
      in [:le_simbolo_escrita_corpo, "d"] | [:le_simbolo_escrita_fim, "d"]
        movimento = "d"
        operar("d", :fim_regra, :D)
      in [:le_simbolo_escrita_corpo, "e"] | [:le_simbolo_escrita_fim, "e"]
        movimento = "e"
        operar("e", :fim_regra, :D)

      # === FIM DE UMA REGRA ===
      # Próximo char pode ser 'f' (nova regra) ou '#' (início da cadeia)
      in [:fim_regra, "f"]
        # Salva a transição lida
        transicoes << {
          estado_atual: estado_leitura,
          simbolo_lido: simbolo_leitura,
          estado_destino: estado_destino,
          simbolo_escrito: simbolo_escrita,
          movimento: movimento
        }
        puts "Transição lida: (#{estado_leitura}, #{simbolo_leitura}) -> (#{estado_destino}, #{simbolo_escrita}, #{movimento})"

        # Começa a ler a próxima regra
        estado_leitura = "f"
        simbolo_leitura = ""
        estado_destino = ""
        simbolo_escrita = ""
        operar("f", :le_estado_atual_corpo, :D)

      in [:fim_regra, "#"]
        # Salva a última transição
        transicoes << {
          estado_atual: estado_leitura,
          simbolo_lido: simbolo_leitura,
          estado_destino: estado_destino,
          simbolo_escrito: simbolo_escrita,
          movimento: movimento
        }
        puts "Transição lida: (#{estado_leitura}, #{simbolo_leitura}) -> (#{estado_destino}, #{simbolo_escrita}, #{movimento})"
        puts "============================"
        puts "Total de transições: #{transicoes.length}"
        puts "============================"
        puts ""

        # Começa a ler os símbolos da cadeia w
        operar("#", :le_cadeia_simbolo, :D)
        simbolo_leitura = ""

      # === LEITURA DA CADEIA DE ENTRADA w ===
      # Símbolos: 's' seguido de 'c's, ou '_' (branco)
      in [:le_cadeia_simbolo, "s"]
        simbolo_leitura = "s"
        operar("s", :le_cadeia_simbolo_corpo, :D)
      in [:le_cadeia_simbolo_corpo, "c"]
        simbolo_leitura << "c"
        operar("c", :le_cadeia_simbolo_corpo, :D)

      # Próximo símbolo da cadeia (começa com 's') ou fim (' ')
      in [:le_cadeia_simbolo_corpo, "s"]
        @fita_cadeia << simbolo_leitura
        simbolo_leitura = "s"
        operar("s", :le_cadeia_simbolo_corpo, :D)

      in [:le_cadeia_simbolo_corpo, " "] | [:le_cadeia_simbolo, " "]
        @fita_cadeia << simbolo_leitura if simbolo_leitura != ""

        puts "=========== Fita de símbolos: ==========="
        puts @fita_cadeia.inspect
        puts ""

        # Inicia a simulação da MT
        return submaquina(transicoes)

      else
        puts "Estado MTU: #{@estado}, Lendo: '#{@fita[@cursor]}' - Sem transição"
        return false
      end
    end
  end

  def submaquina(transicoes)
    # Estado inicial: o estado_atual da primeira transição
    estado_mt = transicoes[0][:estado_atual]
    @cursor_leitura = 0

    # Adiciona branco no final da fita de trabalho
    @fita_cadeia << "_"

    puts "=========== Simulando MT ==========="
    puts "Estado inicial: #{estado_mt}"
    puts ""

    passos = 0
    max_passos = 10000

    while passos < max_passos
      simbolo_atual = @fita_cadeia[@cursor_leitura] || "_"

      # Busca transição linearmente (sem hash)
      resultado = nil
      i = 0
      while i < transicoes.length
        t = transicoes[i]
        if comparar(t[:estado_atual], estado_mt) && comparar(t[:simbolo_lido], simbolo_atual)
          resultado = t
          break
        end
        i += 1
      end

      if resultado.nil?
        puts "Sem transição para (#{estado_mt}, #{simbolo_atual})"
        puts ""
        if estado_aceitacao?(estado_mt)
          puts "=========================================="
          puts ">>> ACEITA! Estado final: #{estado_mt} <<<"
          puts "=========================================="
          return true
        else
          puts "=========================================="
          puts ">>> REJEITA! Estado: #{estado_mt} <<<"
          puts "=========================================="
          return false
        end
      end

      puts "Passo #{passos + 1}: (#{estado_mt}, #{simbolo_atual}) -> (#{resultado[:estado_destino]}, #{resultado[:simbolo_escrito]}, #{resultado[:movimento]})"

      # Aplica a transição
      @fita_cadeia[@cursor_leitura] = resultado[:simbolo_escrito]
      estado_mt = resultado[:estado_destino]

      if resultado[:movimento] == "d"
        @cursor_leitura += 1
        if @cursor_leitura >= @fita_cadeia.length
          @fita_cadeia << "_"
        end
      else
        @cursor_leitura -= 1
        if @cursor_leitura < 0
          @fita_cadeia.unshift("_")
          @cursor_leitura = 0
        end
      end

      passos += 1
    end

    puts "LIMITE DE PASSOS ATINGIDO (#{max_passos})"
    false
  end

  # Compara dois tokens caractere a caractere
  def comparar(a, b)
    return false if a.length != b.length
    i = 0
    while i < a.length
      return false if a[i] != b[i]
      i += 1
    end
    true
  end

  # Estado de aceitação: começa com 'f' seguido de 'b's
  def estado_aceitacao?(estado)
    estado.length >= 2 && estado[0] == 'f' && estado[1] == 'b'
  end

  def operar(escrever, estado, movimento = :D)
    @fita[@cursor] = escrever
    @estado = estado
    if movimento == :D
      @cursor += 1
    else
      @cursor -= 1
    end
  end

  def fita
    @fita_cadeia
  end

  def cursor
    @cursor_leitura
  end
end
