require "spec_helper"
require "pandoc_abnt"
require "json"

describe PandocAbnt::ListaFilter do


  describe "#lista?" do
    context "quando lista ordenada com letras" do
      let(:input){"spec/fixtures/files/listas/lista-letras-termiando-com-ponto.pandoc.json"}
      it "returna true" do
        f = PandocAbnt::ListaFilter.new
        node = JSON.parse(IO.read(input))["blocks"][0]
        expect(f.lista?(node)).to be true
      end
    end
    context "quando nó contem parágrafo qualquer" do
      let(:node){{"t"=>"Para", "c"=>[{"t"=>"Str", "c"=>"fonte:"}, {"t"=>"Space", "c"=>[]}, {"t"=>"Str", "c"=>"Autor."}]}}
      it "returna false" do
        f = PandocAbnt::ListaFilter.new
        expect(f.lista?(node)).to be false
      end
    end
  end


  describe "#filtra_json", :filtra_json do
    let(:dir){"spec/fixtures/files/listas"}
    let(:output){dir + '/' + File.basename(input, '.pandoc.json') + '.transformacao-esperada.json'}
          
    context "Lista ordenada com letras e terminando com '.'" do
      let(:input){"#{dir}/lista-letras-termiando-com-ponto.pandoc.json"}
      it "Substitui o ponto por ';' e mantem ponto no último item" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Lista ordenada com letras e terminando com ';'" do
      let(:input){"#{dir}/lista-letras-termiando-com-ponto-e-virgula.pandoc.json"}
      it "Substitui apenas o último ';' por ponto" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end


    context "Lista ordenada com letras e itens finalizando com '.' e ';'" do
      let(:input){"#{dir}/lista-letras-termiando-com-ponto-e-virgula-mix.pandoc.json"}
      it "Troca todos internos termiando com '.' para ';' e finaliza o último com '.'" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Lista numerica e itens finalizando com '.' e ';'" do
      let(:input){"#{dir}/lista-numerica-termiando-com-ponto-e-virgula-mix.pandoc.json"}
      it "Troca todos internos termiando com '.' para ';' e finaliza o último com '.'" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Lista que utiliza letras e separadas por ponto em vez de parenteses, ex: a." do
      let(:input){"#{dir}/lista-letras-separada-por-ponto-mix.pandoc.json"}
      it "Troca todos internos termiando com '.' para ';' e finaliza o último com '.'" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Lista não ordenada" do
      let(:input){"#{dir}/lista-nao-ordenada-mix.pandoc.json"}
      it "Corrige pontuação final adicionando ';' ou '.' quando necessário" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Lista não ordenada terminada com letra" do
      let(:input){"#{dir}/lista-nao-ordenada-terminando-com-letra-mix.pandoc.json"}
      it "Corrige pontuação final adicionando ';' ou '.' quando necessário" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Lista necessitando iniciar com Maiúsculo escritas com nonbreaking space" do
      let(:input){"#{dir}/lista-maiusculo.pandoc.json"}
      it "Mantém o case e adiciona pontuação necessária" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Alíneas com texto digitado indentado na lista", :alinea do
      let(:input){"#{dir}/alineas-texto-indentado.pandoc.json"}
      it "Corrige pontuação final adicionando ';' ou '.' quando necessário" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Alíneas com texto digitado sem indentado", :alinea do
      let(:input){"#{dir}/alineas-texto-sem-indentado.pandoc.json"}
      it "Mantém a pontuação digita e corrige apenas o case das primeiras letras dos itens para minúsculo" do
        f = PandocAbnt::ListaFilter.new
        filtrado = f.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

  end

end
