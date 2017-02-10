require 'json'

module PandocAbnt

  # Essa classe é responsável por 
  # @see Trabalho#configuracao
  class FiguraFilter

    def reformata_figura_latex(latex_code, fonte)

    image_regex = /\\includegraphics.*/
    caption_regex = /\\caption.*/
    
    
    figura_abntex = <<LATEX
\\begin{figure}[htbp]
#{latex_code.match caption_regex}
\\begin{center}
#{latex_code.match image_regex}
\\end{center}
\\legend{#{fonte}}
\\end{figure}
LATEX
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

    def convert_to_latex(node)
    end

    def filtra_json(pandoc_json_tree)
      # Exemplo de código:
      # [{"unMeta":{}},[{"t":"Para","c":[{"t":"Image","c":[["id",[],[["width","30%"]]],[{"t":"Str","c":"Título"}],["imagem.png","fig:"]]}]},{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}]]
      tree = JSON.parse(pandoc_json_tree)
      meta = tree[0]
      
      filtrados = []
      anterior = nil
      tree[1].each do |node|
        
        if (fonte?(node) and imagem?(anterior)) then
          imagem_latex = convert_to_latex(anterior)
          fonte_latex = convert_to_latex(node)
          texcode = <<TEX
\\begin{figure}[htbp]
\\caption{Legenda da figura}\\label{id}
\\begin{center}
\\includegraphics[width=0.30000\\textwidth]{imagem.png}
\\end{center}
\\legend{Fonte: Autor}
\\end{figure}
TEX
          raw_tex = {"t"=>"RawBlock","c"=>["latex",texcode]}
          
          filtrados.pop # remote o anterior
          filtrados << raw_tex
        else
          filtrados << node
        end
        
        anterior = node
      end
       
      JSON.generate([meta,filtrados])
      
      
#      result = <<-LATEX [{"unMeta":{}},[{"t":"RawBlock","c":["latex","\\begin{figure}[htbp]\n\\caption{Legenda da figura}\\label{id}\n\\begin{center}\n\\includegraphics[width=0.30000\\textwidth]{imagem.png}\n\\end{center}\n\\legend{Fonte: Autor.}\n\\end{figure}"]}]]

    end
    
  end
end
