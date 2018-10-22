require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format progress}
end

task :default => [:spec, :cucumber]

desc "Cria/recria as fixtures"
task :fixtures do

  #FIXME remover original

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

    original = "lista-numerica-termiando-com-ponto-e-virgula-mix.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    original = "lista-letras-separada-por-ponto-mix.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    original = "lista-nao-ordenada-mix.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    original = "lista-nao-ordenada-terminando-com-letra-mix.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    original = "lista-maiusculo.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"

    original = "alineas-texto-sem-indentado.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}"
  end

  Dir.chdir("spec/fixtures/files/quadros") do
    original = "quadro-com-id-titulo-e-fonte.md"
    system "pandoc -f markdown+raw_tex --wrap=none #{original} -o #{original.ext('.pandoc.json')}"
    #system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.transformacao-esperada.md')} -o #{original.ext('.transformacao-esperada.json')}" # removido pq não funciona mais o parse com código fore do begin e and longtable.

    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.apenas-tabela.md')} -o #{original.ext('.apenas-tabela.json')}"
    system "pandoc -f markdown+raw_tex --wrap=none #{original.ext('.apenas-tabela.md')} -o #{original.ext('.apenas-tabela.tex')}"
  end

end
