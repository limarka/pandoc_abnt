require 'json'
require 'open3'

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
\\legend{#{fonte.strip}}
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

    def filtra_json(pandoc_json_tree)
      # Exemplo de código:
      # [{"unMeta":{}},[{"t":"Para","c":[{"t":"Image","c":[["id",[],[["width","30%"]]],[{"t":"Str","c":"Título"}],["imagem.png","fig:"]]}]},{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}]]
      tree = JSON.parse(pandoc_json_tree)
      meta = tree[0]
      
      filtrados = []
      anterior = nil
      
      if not tree[1]
        raise ArgumentError, "Problema no argumento passado: #{pandoc_json_tree}"
      end
      
      tree[1].each do |node|
        
        if (fonte?(node) and imagem?(anterior)) then
          imagem_latex = convert_to_latex([meta,[anterior]])
          fonte_latex = convert_to_latex([meta,[node]])
          texcode = reformata_figura_latex(imagem_latex, fonte_latex)
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
