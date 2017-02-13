require "spec_helper"
require "pandoc_abnt"
require "json"

describe PandocAbnt::FiguraFilter do

  describe "#reformata_figura_latex" do
  
    context "quando figura possui caption" do
      let(:figura_pandoc_latex){<<-LATEX
\\begin{figure}[htbp]
\\centering
\\includegraphics[width=0.30000\\textwidth]{imagem.png}
\\caption{Legenda da figura}\\label{id}
\\end{figure}
LATEX
}
      let(:fonte){"Fonte: Autor"}
      let(:figura_abntex){<<-LATEX
\\begin{figure}[htbp]
\\caption{Legenda da figura}\\label{id}
\\begin{center}
\\includegraphics[width=0.30000\\textwidth]{imagem.png}
\\end{center}
\\legend{Fonte: Autor}
\\end{figure}
LATEX
}
      it "move caption para cima e inclui fonte" do
        ff = PandocAbnt::FiguraFilter.new
        latex_abnt = ff.reformata_figura_latex(figura_pandoc_latex,fonte)
        expect(latex_abnt).to eq(figura_abntex)
      end
    end
  
  end


  describe "#reformata_tabela_latex", :tabela do
  
    context "quando figura possui caption" do
      let(:input){"spec/fixtures/files/tabelas/simple_tables-with-footnote.tabela-pandoc.tex"}
      let(:output){"spec/fixtures/files/tabelas/simple_tables-with-footnote.abntex.tex"}
      let(:fonte){"Fonte: Autor."}
      it "insere a fonte na tabela" do
        ff = PandocAbnt::FiguraFilter.new
        latex_abnt = ff.reformata_tabela_latex(IO.read(input),fonte)
        expect(latex_abnt).to include(IO.read(output))
      end
    end
  
  end



  describe "#convert_to_latex" do
    let(:input){"spec/fixtures/files/imagem.json"}
    let(:output){"spec/fixtures/files/imagem.tex"}

    it "converte json-pandoc hash passado para latex" do
      json_hash_code = JSON.parse(IO.read(input)) 
      ff = PandocAbnt::FiguraFilter.new
      latex_code = ff.convert_to_latex(json_hash_code)
      expect(latex_code).to eq(IO.read(output))
    end
  end

  describe "#fonte?" do
    context "quando nó contem parágrafo com fonte" do
      let(:node){{"t"=>"Para", "c"=>[{"t"=>"Str", "c"=>"Fonte:"}, {"t"=>"Space", "c"=>[]}, {"t"=>"Str", "c"=>"Autor."}]}}
      it "returna true" do
        ff = PandocAbnt::FiguraFilter.new
        expect(ff.fonte?(node)).to be true
      end
    end
    context "quando nó contem parágrafo que não inicia com 'Fonte:'" do
      let(:node){{"t"=>"Para", "c"=>[{"t"=>"Str", "c"=>"fonte:"}, {"t"=>"Space", "c"=>[]}, {"t"=>"Str", "c"=>"Autor."}]}}
      it "returna false" do
        ff = PandocAbnt::FiguraFilter.new
        expect(ff.fonte?(node)).to be false
      end
    end
  end


  describe "#imagem?" do
    context "quando nó contem parágrafo com imagem" do
      let(:node){{"t"=>"Para", "c"=>[{"t"=>"Image", "c"=>[["id", [], [["width", "30%"]]], [{"t"=>"Str", "c"=>"Título"}], ["imagem.png", "fig:"]]}]}}
      it "returna true" do
        ff = PandocAbnt::FiguraFilter.new
        expect(ff.imagem?(node)).to be true
      end
    end
    context "quando nó contem parágrafo texto" do
      let(:node){{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}}
      it "returna false" do
        ff = PandocAbnt::FiguraFilter.new
        expect(ff.imagem?(node)).to be false
      end
    end
  end


  describe "#tabela?", :tabela do
    context "quando nó contem tabela" do
      let(:node){{"t"=>"Table", "c"=>nil}}
      it "returna true" do
        ff = PandocAbnt::FiguraFilter.new
        expect(ff.tabela?(node)).to be true
      end
    end
    context "quando nó contem parágrafo texto" do
      let(:node){{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}}
      it "returna false" do
        ff = PandocAbnt::FiguraFilter.new
        expect(ff.tabela?(node)).to be false
      end
    end
  end


  describe "#filtra_json", :filtra_json do
    context "figura com título, tamanho e id, fonte separado por parágrafo", :figura do
      let(:input){"spec/fixtures/files/p-fig-caption-width-p-fonte.original.json"}
      let(:output){"spec/fixtures/files/p-fig-caption-width-p-fonte.output.json"}
      it "Retorna árvore com código abntex2 incluído" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "Tabela com título, id e fonte separado por parágrafo", :tabela do
      let(:input){"spec/fixtures/files/tabelas/simple_tables-with-footnote.pandoc.json"}
      let(:output){"spec/fixtures/files/tabelas/simple_tables-with-footnote.abntex.json"}
      it "Retorna árvore com código abntex2 incluído" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end
  end

end
