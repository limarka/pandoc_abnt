require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :fixtures do
  Dir.chdir("spec/fixtures/files/tabelas") do
    system "pandoc -f markdown+raw_tex simple_tables-with-footnote.md -o simple_tables-with-footnote.pandoc.json"
    system "pandoc -f markdown+raw_tex simple_tables-with-footnote.md -o simple_tables-with-footnote.pandoc.tex"
    system "pandoc -f markdown+raw_tex simple_tables-with-footnote.abntex.tex -o simple_tables-with-footnote.abntex.json"
  end
  
end
