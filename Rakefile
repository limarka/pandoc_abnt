require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Cria/recria as fixtures"
task :fixtures do
  Dir.chdir("spec/fixtures/files/tabelas") do

    system "pandoc -f markdown+raw_tex simple_tables-with-footnote.md -o simple_tables-with-footnote.pandoc.json"
    system "pandoc -f markdown+raw_tex simple_tables-with-footnote.md -o simple_tables-with-footnote.pandoc.tex"
    system "pandoc -f markdown+raw_tex simple_tables-with-footnote.abntex.tex -o simple_tables-with-footnote.abntex.json"

    original = "pipe_tables-cronograma.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.tex')}"
    # criar original.ext('.pandoc-tabela.tex') : Código latex da tabela que será formatada (remove a fonte de pandoc.tex)
    # criar original.ext('.abntex.tex') : Código esperado para o arquivo final (inclui fonte como legenda)
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.abntex.tex')} -o #{original.ext('.abntex.json')}"
  end
  
  Dir.chdir("spec/fixtures/files/listas") do
    original = "lista-letras-termiando-com-ponto.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"
    
    original = "lista-letras-termiando-com-ponto-e-virgula.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    
    original = "lista-letras-termiando-com-ponto-e-virgula-mix.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    
    
    #system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.tex')}"
    # criar original.ext('.pandoc-tabela.tex') : Código latex da tabela que será formatada (remove a fonte de pandoc.tex)
    # criar original.ext('.abntex.tex') : Código esperado para o arquivo final (inclui fonte como legenda)
    #system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.abntex.tex')} -o #{original.ext('.abntex.json')}"
  end
  
end
