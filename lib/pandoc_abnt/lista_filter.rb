require 'json'
require 'open3'

module PandocAbnt

  # Essa classe é responsável por filtrar as listas para adaptá-las as normas da ABNT.
  class ListaFilter

    # Verifica se node é um parágrafo que inicia com "Fonte:"
    def lista?(node)
      node["t"] == "OrderedList"
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

    def processa_items_da_lista(lista)
      # lista["c"][0]: [1,{"t":"LowerAlpha"},{"t":"OneParen"}]
      itens = lista["c"][1]
#      byebug
      itens.each do |item|
        # último item da lista
        if item == itens.last then
          # adiciona ou troca último caracter (';') para ponto final
          last_token = ultimo_tolken_do_item(item)
          if last_token["t"] == "Str" then
            str = last_token["c"]
            if str.end_with?(";") then
              last_token["c"] = str.gsub(/;$/,'.')
            end
          end
        else
        # itens internos, troca . por ';'
          last_token = ultimo_tolken_do_item(item)
          if last_token["t"] == "Str" then
            str = last_token["c"]
            if str.end_with?(".") then
              last_token["c"] = str.gsub(/\.$/,';')
            end
          end

        end
        
      end
      lista
    end

    #
    # Converte a seguinte lista:
    #
    # a) item 1.
    # b) item 2.
    # c) item 3.
    #
    # Para:
    #
    # a) item 1;
    # b) item 2;
    # c) item 3.

    def filtra_json(pandoc_json_tree)
      # Exemplo de código:
      
      # {"blocks":[{"t":"OrderedList","c":[[1,{"t":"LowerAlpha"},{"t":"OneParen"}],[[{"t":"Plain","c":[{"t":"Str","c":"item"},{"t":"Space"},{"t":"Str","c":"1."}]}],[{"t":"Plain","c":[{"t":"Str","c":"item"},{"t":"Space"},{"t":"Str","c":"2."}]}],[{"t":"Plain","c":[{"t":"Str","c":"item"},{"t":"Space"},{"t":"Str","c":"3."}]}]]]}],"pandoc-api-version":[1,17,0,4],"meta":{}}
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
        if (lista?(node)) then
          lista_modificada = processa_items_da_lista(node)
          filtrados << lista_modificada
        else
          filtrados << node
        end
      end
      JSON.generate({"blocks"=>filtrados, "pandoc-api-version" => api, "meta" => meta})
    end
    
    private
      def ultimo_tolken_do_item(item)
      # [{"t"=>"Plain", "c"=>[{"t"=>"Str", "c"=>"item"}, {"t"=>"Space"}, {"t"=>"Str", "c"=>"1."}]}]
      item[0]["c"].last if item[0]["t"] == "Plain"
    end

  end
end
