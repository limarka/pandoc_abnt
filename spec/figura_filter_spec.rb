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


  describe "#filtra_json" do
    context "figura com título, tamanho e id, fonte separado por parágrafo" do
      let(:markdown_code){<<TEXT
![Título](imagem.png){#id width=30%}

Fonte: Autor.
TEXT
}
      let(:original_json_tree){<<TREE
[{"unMeta":{}},[{"t":"Para","c":[{"t":"Image","c":[["id",[],[["width","30%"]]],[{"t":"Str","c":"Título"}],["imagem.png","fig:"]]}]},{"t":"Para","c":[{"t":"Str","c":"Fonte:"},{"t":"Space","c":[]},{"t":"Str","c":"Autor."}]}]]
TREE
}
      let(:expected_tree){"[{\"unMeta\":{}},[{\"t\":\"RawBlock\",\"c\":[\"latex\",\"\\\\begin{figure}[htbp]\\n\\\\caption{Legenda da figura}\\\\label{id}\\n\\\\begin{center}\\n\\\\includegraphics[width=0.30000\\\\textwidth]{imagem.png}\\n\\\\end{center}\\n\\\\legend{Fonte: Autor}\\n\\\\end{figure}\\n\"]}]]"}
      it "Retorna árvore com código latex incluído" do
        ff = PandocAbnt::FiguraFilter.new
        filtrado = ff.filtra_json(original_json_tree)
        expect(filtrado).to eq(expected_tree)
      end
    end
  end

end
