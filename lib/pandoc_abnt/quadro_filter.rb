require 'json'
require 'open3'

module PandocAbnt

  # Reconhece a sintaxe de quadro e converte para o código latex de um quadro segundo o abnTeX2.
  class QuadroFilter
    
    def transforma_em_quadro(latex_code, id, titulo, fonte)
      #inicio = latex_code.lines[0..-2].join ""
      begin_longtable = latex_code.lines[0].strip
      tabela_codigo_interno_begin = latex_code.lines[1..-2].join("").strip
      abntex_code = <<LATEX
\\renewcommand\\LTcaptype{quadro}
#{begin_longtable}
\\caption{#{titulo.strip}\\label{#{id}}}\\tabularnewline
#{tabela_codigo_interno_begin}
\\caption*{#{fonte.strip}}
\\end{longtable}
\\renewcommand\\LTcaptype{table}
LATEX
      abntex_code.strip
    end
    
    # Verifica se node é um parágrafo que inicia com "Fonte:"
    def fonte?(node)
    # {"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}
      node["t"] == "Para" and node["c"][0]["c"] == "Fonte:"
    end
  
    # Verifica se node contém apenas uma imagem
    def imagem?(node)
# {"t":"Para","c":[{"t":"Image","c":[["id",[],[["width","30%"]]],[{"t":"Str","c":"Título"}],["imagem.png","fig:"]]}]}

      node["t"] == "Para" and node["c"][0]["t"] == "Image"
    end

    # Verifica se node é uma tabela
    def tabela?(node)
    # {"t":"Table","c":[[{"t":"Str","c":"Demonstration"},{"t":"Space"},{"t":"Str","c":"of"},{"t":"Space"},{"t":"Str","c":"simple"},{"t":"Space"},{"t":"Str","c":"table"},{"t":"Space"},{"t":"Str","c":"syntax."},{"t":"Space"},{"t":"RawInline","c":["tex","\\label{mytable}"]}],[{"t":"AlignRight"},{"t":"AlignLeft"},{"t":"AlignCenter"},{"t":"AlignDefault"}],[0,0,0,0],[[{"t":"Plain","c":[{"t":"Str","c":"Right"}]}],[{"t":"Plain","c":[{"t":"Str","c":"Left"}]}],[{"t":"Plain","c":[{"t":"Str","c":"Center"}]}],[{"t":"Plain","c":[{"t":"Str","c":"Default"}]}]],[[[{"t":"Plain","c":[{"t":"Str","c":"12"}]}],[{"t":"Plain","c":[{"t":"Str","c":"12"}]}],[{"t":"Plain","c":[{"t":"Str","c":"12"}]}],[{"t":"Plain","c":[{"t":"Str","c":"12"}]}]],[[{"t":"Plain","c":[{"t":"Str","c":"123"}]}],[{"t":"Plain","c":[{"t":"Str","c":"123"}]}],[{"t":"Plain","c":[{"t":"Str","c":"123"}]}],[{"t":"Plain","c":[{"t":"Str","c":"123"}]}]],[[{"t":"Plain","c":[{"t":"Str","c":"1"}]}],[{"t":"Plain","c":[{"t":"Str","c":"1"}]}],[{"t":"Plain","c":[{"t":"Str","c":"1"}]}],[{"t":"Plain","c":[{"t":"Str","c":"1"}]}]]]]}
      node["t"] == "Table"
    end

    # Verifica se node é um parágrafo que inicia com "Quadro #id: título"
    def quadro?(node)
      # Texto original: 
      # Quadro perfil: Perfil dos voluntários do experimento
      #
      # Depois do parse:
      #
      # {"t"=>"Para","c"=>[{"t"=>"Str","c"=>"Quadro"},{"t"=>"Space"},{"t"=>"Str","c"=>"perfil:"},{"t"=>"Space"},{"t"=>"Str","c"=>"Perfil"},{"t"=>"Space"},{"t"=>"Str","c"=>"dos"},{"t"=>"Space"},{"t"=>"Str","c"=>"voluntários"},{"t"=>"Space"},{"t"=>"Str","c"=>"do"},{"t"=>"Space"},{"t"=>"Str","c"=>"experimento"}]}
      para = node["c"]
      
      node["t"] == "Para" and node["c"].length>=5 and string_contendo?("Quadro",para[0]) and space?(para[1]) and quadro_id?(para[2]) and space?(para[3]) and string?(para[4])
    end

    def string_contendo?(string, node)
      node["t"] == "Str" and node["c"]==string
    end

    # Verifica se o node_p contém um string que poderia representar o id de um quadro
    #
    # Ex: {"t"=>"Str","c"=>"perfil2:"}
    def quadro_id?(node)
      node["t"] == "Str" and node["c"].match(/[[:alpha:]]+\w*\:/)
    end

    # Verifica se o node (parágrafo) contém uma descrição de Quadro, e extrai o id e título.
    def extrai_id_titulo_do_quadro(node, apimeta)
      # {"t"=>"Para","c"=>[{"t"=>"Str","c"=>"Quadro"},{"t"=>"Space"},{"t"=>"Str","c"=>"perfil:"},{"t"=>"Space"},{"t"=>"Str","c"=>"Perfil"},{"t"=>"Space"},{"t"=>"Str","c"=>"dos"},{"t"=>"Space"},{"t"=>"Str","c"=>"voluntários"},{"t"=>"Space"},{"t"=>"Str","c"=>"do"},{"t"=>"Space"},{"t"=>"Str","c"=>"experimento"}]}
      return nil unless quadro?(node)
      
      id = node["c"][2]["c"][0..-2]
      titulo_nodes = node["c"][4..-1]
      para = {"t" => "Para", "c" => titulo_nodes}
      
      titulo = convert_to_latex(apimeta.merge("blocks"=>[para]))
      return id, titulo
    end

    def space?(node)
      node["t"] == "Space"
    end

    def string?(node)
      node["t"] == "Str"
    end


    # Converte node para latex
    def convert_to_latex(node)
      latex_code = nil
      Open3.popen3("pandoc -f json -t latex --wrap=none") {|stdin, stdout, stderr, wait_thr|
        stdin.write(node.to_json)
        stdin.close  # stdin, stdout and stderr should be closed explicitly in this form.
        latex_code = stdout.read

        pid = wait_thr.pid # pid of the started process.
        exit_status = wait_thr.value # Process::Status object returned.
      }
      latex_code
    end

    def atualiza_imagem_width(node)
      # {"t"=>"Para", "c"=>[{"t"=>"Image", "c"=>[["id", [], [["largura", "30%"]]], [{"t"=>"Str", "c"=>"Título"}], ["imagem.png", "fig:"]]}]}
      # node["c"][0]["c"][2] << ["width","30%"]
      atributos = node["c"][0]["c"][0][2]
      atributos.each_with_index do |att, index|
        if att[0] == "largura" then
          atributos[index][0] = "width"
          break
        end
      end
      node
    end

    def filtra_json(pandoc_json_tree)
      # Exemplo de código:
      # [{"unMeta":{}},[{"t":"Para","c":[{"t":"Image","c":[["id",[],[["width","30%"]]],[{"t":"Str","c":"Título"}],["imagem.png","fig:"]]}]},{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}]]
      tree = JSON.parse(pandoc_json_tree)
      meta = tree["meta"]
      blocks = tree["blocks"]
      api = tree["pandoc-api-version"]
      
      filtrados = []
      anterior = nil
      
      if not blocks
        raise ArgumentError, "Problema no argumento passado: #{pandoc_json_tree}"
      end
      
      blocks.each do |node|
        
        if (fonte?(node) and tabela?(anterior) and quadro?(filtrados[-2])) then

          tabela_latex = convert_to_latex({"blocks"=>[anterior], "pandoc-api-version" => api, "meta" => meta})
          fonte_latex = convert_to_latex({"blocks"=>[node], "pandoc-api-version" => api, "meta" => meta})
          id, titulo = extrai_id_titulo_do_quadro(filtrados[-2], {"pandoc-api-version" => api, "meta" => meta})
          texcode = transforma_em_quadro(tabela_latex, id, titulo, fonte_latex)
          raw_tex = {"t"=>"RawBlock","c"=>["latex",texcode]}

          filtrados.pop # remove tabela          
          filtrados.pop # remove quadro parágrafo
          filtrados << raw_tex
        else
          filtrados << node
        end
        
        anterior = node
      end
       
      JSON.generate({"blocks"=>filtrados, "pandoc-api-version" => api, "meta" => meta})
      
      
#      result = <<-LATEX [{"unMeta":{}},[{"t":"RawBlock","c":["latex","\\begin{figure}[htbp]\n\\caption{Legenda da figura}\\label{id}\n\\begin{center}\n\\includegraphics[width=0.30000\\textwidth]{imagem.png}\n\\end{center}\n\\legend{Fonte: Autor.}\n\\end{figure}"]}]]

    end
    
  end
end
