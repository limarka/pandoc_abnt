require 'json'
require 'open3'

module PandocAbnt

  # Essa classe é responsável por alterar a área sintática
  # dos nós de imagem para um nó raw_tex com imgagem
  # no formato do abntex2.
  # @see Trabalho#configuracao
  class FiguraFilter

    def ler_escala(image_node)
      # {"t"=>"Para", "c"=>[{"t"=>"Image", "c"=>[["id", [], [["escala", "30%"]]], [{"t"=>"Str", "c"=>"Título"}], ["imagem.png", "fig:"]]}]}
      if image_node["c"][0]["c"][0][2].empty?
        nil
      else
        if image_node["c"][0]["c"][0][2][0][0] == "escala"
          image_node["c"][0]["c"][0][2][0][1]
        else
          nil
        end
      end
    end
    def atualiza_includegraphics(includegraphics, image_node)
      # "\\includegraphics{imagem.png}"
      escala = ler_escala(image_node)
      result = nil
      if escala
        result = "\\includegraphics[scale=#{escala}]{#{includegraphics.split("{")[1]}"
      else
        result = includegraphics
      end
    end

    def reformata_figura_latex(latex_code, fonte, image_node)
      image_regex = /\\includegraphics.*/
      caption_regex = /\\caption.*/
      hypertarget_regex = /\\hypertarget.*/
      includegraphics = atualiza_includegraphics("#{latex_code.match(image_regex)}", image_node)

=begin
Como vem:
\begin{figure}
\hypertarget{arquitetura}{%
\centering
\includegraphics{limarka-arquitetura.jpg}
\caption{Arquitetura do Limarka}\label{arquitetura}
}
\end{figure}

Como deve ser:

\begin{figure}[htbp]
\hypertarget{arquitetura}{%
\caption{Arquitetura do Limarka}\label{arquitetura}
\begin{center}
\includegraphics[scale=0.4]{limarka-arquitetura.jpg}
\end{center}
}
\legend{Fonte: Autor.}
\end{figure}
"""
=end
      figura_abntex = <<-LATEX
\\begin{figure}[htbp]
#{latex_code.match hypertarget_regex}
#{latex_code.match caption_regex}
\\begin{center}
#{includegraphics}
\\end{center}
}
\\legend{#{fonte.strip}}
\\end{figure}
LATEX
    end

    def reformata_tabela_latex(latex_code, fonte)
      inicio = latex_code.lines[0..-2].join ""
      abntex_code = <<LATEX
#{inicio}\\caption*{#{fonte.strip}}
\\end{longtable}
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

    # Verifica se node é uma tabela
    def tabela?(node)
    # {"t":"Table","c":[[{"t":"Str","c":"Demonstration"},{"t":"Space"},{"t":"Str","c":"of"},{"t":"Space"},{"t":"Str","c":"simple"},{"t":"Space"},{"t":"Str","c":"table"},{"t":"Space"},{"t":"Str","c":"syntax."},{"t":"Space"},{"t":"RawInline","c":["tex","\\label{mytable}"]}],[{"t":"AlignRight"},{"t":"AlignLeft"},{"t":"AlignCenter"},{"t":"AlignDefault"}],[0,0,0,0],[[{"t":"Plain","c":[{"t":"Str","c":"Right"}]}],[{"t":"Plain","c":[{"t":"Str","c":"Left"}]}],[{"t":"Plain","c":[{"t":"Str","c":"Center"}]}],[{"t":"Plain","c":[{"t":"Str","c":"Default"}]}]],[[[{"t":"Plain","c":[{"t":"Str","c":"12"}]}],[{"t":"Plain","c":[{"t":"Str","c":"12"}]}],[{"t":"Plain","c":[{"t":"Str","c":"12"}]}],[{"t":"Plain","c":[{"t":"Str","c":"12"}]}]],[[{"t":"Plain","c":[{"t":"Str","c":"123"}]}],[{"t":"Plain","c":[{"t":"Str","c":"123"}]}],[{"t":"Plain","c":[{"t":"Str","c":"123"}]}],[{"t":"Plain","c":[{"t":"Str","c":"123"}]}]],[[{"t":"Plain","c":[{"t":"Str","c":"1"}]}],[{"t":"Plain","c":[{"t":"Str","c":"1"}]}],[{"t":"Plain","c":[{"t":"Str","c":"1"}]}],[{"t":"Plain","c":[{"t":"Str","c":"1"}]}]]]]}
      node["t"] == "Table"
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

        if (fonte?(node) and imagem?(anterior)) then
          image_node = atualiza_imagem_width(anterior)
          imagem_latex = convert_to_latex({"blocks"=>[image_node], "pandoc-api-version" => api, "meta" => meta})
          fonte_latex = convert_to_latex({"blocks"=>[node], "pandoc-api-version" => api, "meta" => meta})
          texcode = reformata_figura_latex(imagem_latex, fonte_latex, image_node)
          raw_tex = {"t"=>"RawBlock","c"=>["tex",texcode.strip]}

          filtrados.pop # remote o anterior
          filtrados << raw_tex
        elsif (fonte?(node) and tabela?(anterior)) then
          tabela_latex = convert_to_latex({"blocks"=>[anterior], "pandoc-api-version" => api, "meta" => meta})
          fonte_latex = convert_to_latex({"blocks"=>[node], "pandoc-api-version" => api, "meta" => meta})
          texcode = reformata_tabela_latex(tabela_latex, fonte_latex)
          raw_tex = {"t"=>"RawBlock","c"=>["tex",texcode.strip]}

          filtrados.pop # remote o anterior
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
