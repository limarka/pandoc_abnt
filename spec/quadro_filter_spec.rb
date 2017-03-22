require "spec_helper"
require "pandoc_abnt"
require "json"

describe PandocAbnt::QuadroFilter, :quadro do

  

  describe "#transforma_em_quadro" do
    context "quando passa qualquer tabela" do
      let(:prefixo){"spec/fixtures/files/quadros/quadro-com-id-titulo-e-fonte.md"}
      let(:input){prefixo.ext('.apenas-tabela.tex')}
      let(:output){prefixo.ext('.transformacao-esperada.md')}
      let(:id){"perfil"}
      let(:titulo){"Perfil dos voluntários do experimento"}
      let(:fonte){"Fonte: Autor."}
      it "gera um quadro abntex2 com id, título e fonte" do
        ff = PandocAbnt::QuadroFilter.new
        latex_abnt = ff.transforma_em_quadro(IO.read(input),id,titulo,fonte)
        expect(latex_abnt.strip).to include(IO.read(output).strip)
      end
    end
  end

  describe "#convert_to_latex" do
    let(:prefixo){"spec/fixtures/files/quadros/quadro-com-id-titulo-e-fonte.md"}
    let(:input){prefixo.ext('.apenas-tabela.json')}
    let(:output){prefixo.ext('.apenas-tabela.tex')}

    it "converte um arquivo json-pandoc contendo uma tabela para código Latex" do
      json_hash_code = JSON.parse(IO.read(input)) 
      ff = PandocAbnt::QuadroFilter.new
      # testa
      latex_code = ff.convert_to_latex(json_hash_code)
      expect(latex_code).to eq(IO.read(output))
    end
  end

  describe "#fonte?" do
    context "quando nó contem parágrafo com fonte" do
      let(:node){{"t"=>"Para", "c"=>[{"t"=>"Str", "c"=>"Fonte:"}, {"t"=>"Space", "c"=>[]}, {"t"=>"Str", "c"=>"Autor."}]}}
      it "returna true" do
        ff = PandocAbnt::QuadroFilter.new
        expect(ff.fonte?(node)).to be true
      end
    end
    context "quando nó contem parágrafo que não inicia com 'Fonte:'" do
      let(:node){{"t"=>"Para", "c"=>[{"t"=>"Str", "c"=>"fonte:"}, {"t"=>"Space", "c"=>[]}, {"t"=>"Str", "c"=>"Autor."}]}}
      it "returna false" do
        ff = PandocAbnt::QuadroFilter.new
        expect(ff.fonte?(node)).to be false
      end
    end
  end


  describe "#tabela?", :tabela do
    context "quando nó contem tabela" do
      let(:node){{"t"=>"Table", "c"=>nil}}
      it "returna true" do
        ff = PandocAbnt::QuadroFilter.new
        expect(ff.tabela?(node)).to be true
      end
    end
    context "quando nó contem parágrafo texto" do
      let(:node){{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}}
      it "returna false" do
        ff = PandocAbnt::QuadroFilter.new
        expect(ff.tabela?(node)).to be false
      end
    end
  end


  describe "#quadro?" do
    context "quando nó contém quadro" do
      let(:node){{"t"=>"Para","c"=>[{"t"=>"Str","c"=>"Quadro"},{"t"=>"Space"},{"t"=>"Str","c"=>"perfil:"},{"t"=>"Space"},{"t"=>"Str","c"=>"Título"},{"t"=>"Space"},{"t"=>"Str","c"=>"do"},{"t"=>"Space"},{"t"=>"Str","c"=>"quadro"}]}}
      it "returna true" do
        ff = PandocAbnt::QuadroFilter.new
        expect(ff.quadro?(node)).to be true
      end
    end
    context "quando nó contem parágrafo texto" do
      let(:node){{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}}
      it "returna false" do
        ff = PandocAbnt::QuadroFilter.new
        expect(ff.tabela?(node)).to be false
      end
    end
  end


  describe "#filtra_json", :filtra_json do
    context "Quadro com id, título e fonte", :figura do
      let(:prefixo){"spec/fixtures/files/quadros/quadro-com-id-titulo-e-fonte.md"}
      let(:input){prefixo.ext('.pandoc.json')}
      let(:output){prefixo.ext('.transformacao-esperada.json')}
      it "Retorna árvore com código abntex2 incluído" do
        ff = PandocAbnt::QuadroFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end
  end

end
