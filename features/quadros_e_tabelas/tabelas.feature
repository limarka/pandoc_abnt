# language: pt
Funcionalidade: Inserir Tabelas conforme as normas da ABNT

As **Tabelas** são formadas por linhas verticais, devem manter suas bordas laterais abertas e geralmente são utilizadas para **dados quantitativos**.

Você pode consultar a [documentação da syntaxe de tabelas em Markdown aqui](http://pandoc.org/MANUAL.html#tables).

Cenário: Incluindo uma tabela com título e fonte
  Dado um arquivo chamado "tabela.md" contendo:
"""
Exemplo de tabela.

  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

: Demonstration of simple table syntax. \label{mytable}

Fonte: Autor.
"""
  Dado eu executo `pandoc -t latex --filter pandoc_abnt tabela.md -o tabela-pandoc_abnt.tex`
  Então o arquivo "tabela-pandoc_abnt.tex" deve conter:
"""
Exemplo de tabela.

\begin{longtable}[]{@{}rlcl@{}}
\caption{Demonstration of simple table syntax. \label{mytable}}\tabularnewline
\toprule
Right & Left & Center & Default\tabularnewline
\midrule
\endfirsthead
\toprule
Right & Left & Center & Default\tabularnewline
\midrule
\endhead
12 & 12 & 12 & 12\tabularnewline
123 & 123 & 123 & 123\tabularnewline
1 & 1 & 1 & 1\tabularnewline
\bottomrule
\caption*{Fonte: Autor.}
\end{longtable}
"""
