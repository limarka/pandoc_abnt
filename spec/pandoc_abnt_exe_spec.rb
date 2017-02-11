require "spec_helper"

describe "exe/pandoc_abnt" do
  
  context "Parágrafo com imagem, id, width e Fonte: no próximo parágrafo" do
    let(:input){"spec/fixtures/files/p-fig-caption-width-p-fonte.md"}
    let(:output){"spec/fixtures/files/p-fig-caption-width-p-fonte.tex"}
    
    before do
      @abntex_code = `bundle exec pandoc -f markdown --to=latex --wrap=none #{input} --filter exe/pandoc_abnt`
    end
    it "gera um node com raw_tex contendo a imagem com a fonte no padrao abntex2" do
      expect(@abntex_code).to eq(IO.read(output))
    end
  end
  
  context "Parágrafo com imagem, id, width e Fonte: com citação no próximo parágrafo" do
    let(:input){"spec/fixtures/files/p-fig-caption-width-p-fonte-cite.md"}
    let(:output){"spec/fixtures/files/p-fig-caption-width-p-fonte-cite.tex"}
    
    before do
      @abntex_code = `bundle exec pandoc -f markdown --to=latex --wrap=none #{input} --filter exe/pandoc_abnt`
    end
    it "gera um node com raw_tex contendo a imagem com a fonte no padrao abntex2" do
      expect(@abntex_code).to eq(IO.read(output))
    end
  end

  context "Texto sem imagem" do
    let(:input){"spec/fixtures/files/texto-sem-figura.md"}
#    let(:output){"spec/fixtures/files/p-fig-caption-width-p-fonte-cite.tex"}
    
    before do
      @abntex_code = `bundle exec pandoc -f markdown --to=latex --wrap=none #{input} --filter exe/pandoc_abnt`
    end
    it "gera o código json normalmente" do
      expect(@abntex_code).to include("Capítulo")
    end
  end

  
end
