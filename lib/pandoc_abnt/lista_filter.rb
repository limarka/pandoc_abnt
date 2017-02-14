require 'json'
require 'open3'

module PandocAbnt

  # Essa classe é responsável por filtrar as listas para adaptá-las as normas da ABNT.
  class ListaFilter



      # Verifica se node é um parágrafo que inicia com "Fonte:"
      def lista?(node)
         lista_ordenada?(node) or lista_nao_ordenada?(node)
      end
      
      def lista_ordenada?(node)
        node["t"] == "OrderedList"
      end

      def lista_nao_ordenada?(node)
        node["t"] == "BulletList"
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

    def processa_items_da_lista(lista)
      # lista["c"][0]: [1,{"t":"LowerAlpha"},{"t":"OneParen"}]

      utiliza_parenteses!(lista) if utiliza_ponto?(lista)

      itens = lista["c"][1] if lista_ordenada?(lista)
      itens = lista["c"] if lista_nao_ordenada?(lista)
#      byebug
      itens.each do |item|
        # último item da lista
        if item == itens.last then
          # adiciona ou troca último caracter (';') para ponto final
          last_token = ultimo_tolken_do_item(lista, item)
          next unless last_token
          if last_token["t"] == "Str" then
            str = last_token["c"]
            if str.end_with?(";") then
              last_token["c"] = str.gsub(/;$/,'.')
            elsif /[[:alnum:]]$/ =~ str
              last_token["c"] << '.'
            end
          end
        else
        # itens internos, troca . por ';'
          last_token = ultimo_tolken_do_item(lista, item)
          next unless last_token
          if last_token["t"] == "Str" then
            str = last_token["c"]
            if str.end_with?(".") then
              last_token["c"] = str.gsub(/\.$/,';')
            elsif /[[:alnum:]]$/ =~ str
              last_token["c"] << ';'
            end
          end

        end
        
      end
      lista
    end



      def ultimo_tolken_do_item(lista, item)
      # [{"t"=>"Plain", "c"=>[{"t"=>"Str", "c"=>"item"}, {"t"=>"Space"}, {"t"=>"Str", "c"=>"1."}]}]
        if lista_ordenada?(lista) and item[0]["t"] == "Plain" then
          item[0]["c"].last
        elsif lista_nao_ordenada?(lista)
          item[0]["c"].last
        else
          nil
        end
      end
    
      def utiliza_ponto?(lista)
        # lista["c"][0]: [1,{"t":"LowerAlpha"},{"t":"Period"}]
        lista_ordenada?(lista) and lista["c"][0][2]["t"] == "Period"
      end

      def utiliza_parenteses!(lista)
        lista["c"][0][2]["t"] = "OneParen"
      end


  end
end
