require "spec_helper"
require "pandoc_abnt"
require "json"

describe PandocAbnt::FiguraFilter, :figura do

  describe "#reformata_figura_latex" do

    context "quando figura possui caption" do
      let(:figura_pandoc_latex){<<-LATEX
\\begin{figure}
\\hypertarget{id}{%
\\centering
\\includegraphics{imagem.png}
\\caption{Título}\\label{id}
}
\\end{figure}
LATEX
}
      let(:fonte){"Fonte: Autor"}
      let(:image_node){{"t"=>"Para", "c"=>[{"t"=>"Image", "c"=>[["id", [], []], [{"t"=>"Str", "c"=>"Título"}], ["imagem.png", "fig:"]]}]}}
      let(:figura_abntex){<<-LATEX
\\begin{figure}[htbp]
\\hypertarget{id}{%
\\caption{Título}\\label{id}
\\begin{center}
\\includegraphics{imagem.png}
\\end{center}
}
\\legend{Fonte: Autor}
\\end{figure}
LATEX
}
      it "move caption para cima e inclui fonte" do
        ff = PandocAbnt::FiguraFilter.new
        latex_abnt = ff.reformata_figura_latex(figura_pandoc_latex,fonte, image_node)
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
    let(:src){"spec/fixtures/files/figuras/imagem.md"}
    let(:input){"#{src}.json"}
    let(:output){"#{src}.tex"}
    before do
      `pandoc #{src} -t json -o #{input}`
      `pandoc #{src} -t latex  -o #{output}`
    end

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

    context "figura com título e fonte separado por parágrafo", :figura do
      let(:input){"spec/fixtures/files/figuras/p-fig-caption-p-fonte.pandoc.json"}
      let(:output){"spec/fixtures/files/figuras/p-fig-caption-p-fonte.pandoc_abnt.json"}
      it "Retorna árvore com código abntex2 incluído" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        filtrado_pretty = JSON.pretty_generate(JSON.parse(filtrado))
        output_pretty = JSON.pretty_generate(JSON.parse(IO.read(output)))
        expect(filtrado_pretty).to eq(output_pretty)
      end
    end


    context "figura com título, width e id, fonte separado por parágrafo", :figura do
      let(:src){"spec/fixtures/files/figuras/p-fig-caption-width-p-fonte.md"}
      let(:input){"#{src}.json"}
      let(:output){"#{src}.abntex.json"}
      before do
        `pandoc #{src} -t json -o #{src}.json`
        `pandoc #{src} -t latex -o #{src}.tex`
        `pandoc -f markdown+raw_tex #{src}.abntex.tex -t json -o #{output}`
      end
      it "Retorna árvore com código abntex2 incluído" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "figura com título, escala e id, fonte separado por parágrafo", :figura, :escala do
      let(:src){"spec/fixtures/files/figuras/p-fig-caption-escala-p-fonte.md"}
      let(:input){"#{src}.json"}
      let(:output){"#{src}.abnt.json"}
      before do
        `pandoc #{src} -t json -o #{src}.json`
        `pandoc #{src} -t latex -o #{src}.tex`
        `pandoc -f markdown+raw_tex #{src}.abnt.tex -t json -o #{src}.abnt.json`
      end

      it "Retorna árvore com código abntex2 incluído e includegraphics com scale" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end

    context "figura com título, escala2 e id, fonte separado por parágrafo", :figura, :escala, :wip do
      let(:src){"spec/fixtures/files/figuras/p-fig-caption-escala2-p-fonte.md"}
      let(:input){"#{src}.json"}
      let(:output){"#{src}.abnt.json"}
      before do
        `pandoc #{src} -t json -o #{src}.json`
        `pandoc #{src} -t latex -o #{src}.tex`
        `pandoc -f markdown+raw_tex #{src}.abnt.tex -t json -o #{src}.abnt.json`
      end

      it "Retorna árvore com código abntex2 incluído e includegraphics com scale" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end


    context "Tabela com título, id e fonte separado por parágrafo", :tabela do
      let(:src){"spec/fixtures/files/tabelas/tabela-simples.md"}
      let(:input){"#{src}.json"}
      let(:output){"#{src}.abntex.json"}
      before do
        `pandoc #{src} -t json -o #{src}.json`
        `pandoc #{src} -t latex -o #{src}.tex --wrap=none`
        `pandoc -f markdown+raw_tex #{src}.abntex.tex -t json -o #{src}.abntex.json --wrap=none`
      end
      it "Retorna árvore com código abntex2 incluído" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(IO.read(input))
        expect(JSON.pretty_generate(JSON.parse(filtrado))).to eq(JSON.pretty_generate(JSON.parse(IO.read(output))))
      end
    end
  end

end
