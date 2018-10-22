# language: en
Feature: Inserir Tabelas conforme as normas da ABNT

    As **Tabelas** são formadas por linhas verticais, devem manter suas bordas 
    laterais abertas e geralmente são utilizadas para **dados quantitativos**. 


Scenario: Incluindo uma tabela com título e fonte
  Given a file named "tabela.md" with:
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
  When I run `pandoc -t latex --filter pandoc_abnt tabela.md -o tabela-pandoc_abnt.tex`
  Then the file named "tabela-pandoc_abnt.tex" should contain:
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
