# language: en
Feature: Configurando escalas ao inserir figuras

    Ao inserir uma figura no texto as vezes desejamos aumentar ou diminuir o
    seu tamanho, chamamos esse recurso de alterar a escala da imagem.
    
    A especificação da escala é realizada através do parâmetro `escala` na figura.
    O filtro irá gerar o código correspondente em Latex para realizar a operação.

Scenario: Inserindo figura com parâmetro escala
  Given a file named "figura.md" with:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

![Arquitetura do Limarka](limarka-arquitetura.jpg){#arquitetura escala=0.2}

Fonte: Autor.
"""
  When I run `pandoc -t latex --filter pandoc_abnt figura.md -o figura-pandoc_abnt.tex`
  Then the file named "figura-pandoc_abnt.tex" should contain:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

\begin{figure}[htbp]
\hypertarget{arquitetura}{%
\caption{Arquitetura do Limarka}\label{arquitetura}
\begin{center}
\includegraphics[scale=0.2]{limarka-arquitetura.jpg}
\end{center}
}
\legend{Fonte: Autor.}
\end{figure}
"""
