# language: en
Feature: Inserir Quadros conforme as normas da ABNT

Os **Quadros**, por outro lado, são formados por linhas verticais e horizontais,
devem ter todas suas extremidades fechadas e são mais utilizados para 
**dados qualitativos**.

![Exemplo de Quadro](https://github.com/abntex/limarka/wiki/imagens/quadros-perfil.png)

Scenario: Incluindo um quadro com título e fonte
  Given a file named "quadro.md" with:
"""
O \autoref{perfil} apresenta o perfil dos voluntários dos experimentos
realizados.

Quadro perfil: Perfil dos voluntários do experimento

|Vol.|Formação acadêmica           |Experiência c/ Latex| Expeiência c/ Markdown|
|:-:|:-----------------------------|-------------------:|:--------------------:|
|1  |Ciência da Computação         |ShareLatex          | Readme/Github|
|2  |Engenharia da Computação      |Viu prof. utilizando|-|
|3  |Engenheiro elétrico (mestrando)|Utiliza para tudo  |-|

Fonte: Autor.

"""
  When I run `pandoc -t latex --filter pandoc_abnt quadro.md -o quadro-pandoc_abnt.tex`
  Then the file named "quadro-pandoc_abnt.tex" should contain:
"""
O \autoref{perfil} apresenta o perfil dos voluntários dos experimentos
realizados.

\renewcommand\LTcaptype{quadro}
\begin{longtable}[]{|c|l|r|c|}
\caption{Perfil dos voluntários do experimento\label{perfil}}\tabularnewline
\toprule
Vol. & Formação acadêmica & Experiência c/ Latex & Expeiência c/ Markdown\tabularnewline
\midrule
\endhead
1 & Ciência da Computação & ShareLatex & Readme/Github\tabularnewline
2 & Engenharia da Computação & Viu prof. utilizando & -\tabularnewline
3 & Engenheiro elétrico (mestrando) & Utiliza para tudo & -\tabularnewline
\bottomrule
\caption*{Fonte: Autor.}
\end{longtable}
\renewcommand\LTcaptype{table}
"""
