# language: pt
Funcionalidade: Configurando escalas ao inserir figuras

Ao inserir uma figura no texto as vezes desejamos aumentar ou diminuir o seu tamanho, chamamos esse recurso de alterar a escala da imagem.

A especificação da escala é realizada através do parâmetro `escala` na figura. O filtro irá gerar o código correspondente em Latex para realizar a operação.

Cenário: Inserindo figura com parâmetro escala
  Dado um arquivo chamado "figura.md" contendo:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

![Arquitetura do Limarka](limarka-arquitetura.jpg){#arquitetura escala=0.2}

Fonte: Autor.
"""
  Quando eu executo `pandoc -t latex --filter pandoc_abnt figura.md -o figura-pandoc_abnt.tex`
  Então o arquivo "figura-pandoc_abnt.tex" deve conter:
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
\fonte{Fonte: Autor.}
\end{figure}
"""
