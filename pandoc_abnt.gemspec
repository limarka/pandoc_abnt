# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pandoc_abnt/version'

Gem::Specification.new do |spec|
  spec.name          = "pandoc_abnt"
  spec.version       = PandocAbnt::VERSION
  spec.authors       = ["Eduardo de Santana Medeiros Alexandre"]
  spec.email         = ["eduardo.ufpb@gmail.com"]

  spec.summary       = %q{Filtro pandoc para converter conteúdos para as Normas da ABNT}
  spec.description   = %q{Adiciona fontes à Imagens e Tabelas.}
  spec.homepage      = "https://github.com/edusantana/pandoc_abnt"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "github_changelog_generator"
  
  
end
