# pandoc_abnt

Filtro pandoc para elaborar documentos de acordo com as normas da abnt.

## Instalação


    $ gem install pandoc_abnt

Requer pandoc `v1.19.2.1` ou superior.

## Utilização

O pandoc_abnt foi elaborado para ser utilizado com o [limarka](https://github.com/abntex/limarka), mas projetado para ser utilizado separadamente:

    pandoc --wrap=none -s --filter pandoc_abnt documento.md -o documento.pdf

## Especificação técnica

[A especificação técnica do panco_abnt é baseada em testes automatizados](https://relishapp.com/edusantana/pandoc-abnt/docs) e sempre retrata o funcionamento real e testado da ferramenta.

**AVISO**: A documentação abaixo pode está desatualizada. Consulte a especificação acima para obter informações mais confiáveis.

## Funcionalidades

### Fonte de Figuras e Tabelas

Para adicionar uma fonte a figura ou tabela, basta adicionar no parágrafo seguinte: `Fonte: texto da fonte`.

Exemplo de Figura:

```markdown
![Título](imagem.png){#id escala=0.3}

Fonte: Autor.
```

Exemplo de Tabela:

```
  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

: Demonstration of simple table syntax. \label{mytable}

Fonte: Autor.
```

Você pode utilizar [qualquer uma das sintaxes de tabela suportadas pelo pandoc](http://pandoc.org/MANUAL.html#tables).

**OBS**: O comando `\label{}` é necessário para permitir refenciar a tabela no Latex.

### Quadros

Exemplo de sintaxe para criar Quadros:

```markdown
Quadro perfil: Perfil dos voluntários do experimento

|Vol.|Formação acadêmica           |Experiência c/ Latex| Expeiência c/ Markdown|
|:-:|:----------------------------:|:------------------:|:---------------------:|
|1  |Ciência da Computação         |ShareLatex          |    Readme/Github      |
|2  |Engenharia da Computação      |Viu prof. utilizando|         -             |
|3  |Engenheiro elétrico (mestrando)|Utiliza para tudo  |         -             |

Fonte: Autor.

```

**OBS**: Esse Quadro deve ser referencia no texto com `\autoref{perfil}`.

### Alíneas

A ABNT especifica que o texto das seções podem ser divididos em *Alíneas*, na prática você PODE utilizar uma lista ordenada por letras para separar o conteúdo de uma seção:

```markdown
a) primeira alínea;

    Texto dentro da primeira alínea.

b) segunda alínea;

    Texto dentro da segunda alínea.

    Mais texto dentro da segunda alínea.

c) terceira alínea;

    Texto dentro da terceira alínea.

d) qualquer coisac.

    Texto dentro da quarta alínea.

Texto fora das alíneas.
```

**OBS**: Perceba que existem *4 espaços em branco* indentado os parágrafos dentro das alíneas.

O pandoc_abnt implementa as seguintes funcionalidas:

- Adiciona o parêntese automaticamente, caso tenha utilizado ponto: `a. -> a)`
- Adiciona o `;` em todas as alíneas, menos a última, que finaliza com ponto `.`. Mesmo que você que você tenha colocado a pontuação errada.
- Aplica letra minúscula no início das alíneas automaticamente.

A alínea a seguir estaria em não conformidade com as Normas da ABNT (NBR 6024:2012). No entanto, o pandoc_abnt ajusta automaticamente para obter o resultado da alínea apresentada anteriormenete, elas são equivalentes:

```markdown
a. Primeira alínea

    Texto dentro da primeira alínea.

b. Segunda alínea

    Texto dentro da segunda alínea.

    Mais texto dentro da segunda alínea.

c. Terceira alínea.

    Texto dentro da terceira alínea.

d. Qualquer coisac;

    Texto dentro da quarta alínea.

Texto fora das alíneas.
```

### Pontuação das listas

De forma semelhante as pontuações das listas são inseridas automaticamente:

```markdown
- Abacate
- Banana
- Côco
```

Será automaticamente corrigido para:

```markdown
- abacate;
- banana;
- côco.
```

Para manter a primeira letra da lista em maiúsculo, deve-se utilizar um *nonbreaking space*:

```markdown
- \ Alberto
- \ Bernadete
- \ Charles
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

A documentação é elaborada através das [features do cucumber](https://relishapp.com/relish/relish/docs/quick-start-guide).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/limarka/pandoc_abnt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
