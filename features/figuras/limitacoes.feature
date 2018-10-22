# language: pt
Funcionalidade: Limitações do pandoc

O pandoc sem este filtro possui as seguintes limitações:

- Não coloca o título em cima
- Não permite colocar título e fonte simultaneamente
- Não permite escalar as imagens
- Não posiciona a figura o mais próximo possível por padrão.

Esta spec apresenta o comportamento normal do pandoc, **sem o uso desse filtro**.

Cenário: Funcionamento normal do pandoc (sem pandoc_abnt)
  Dado um arquivo chamado "figura.md" contendo:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

![Arquitetura do Limarka](limarka-arquitetura.jpg){#arquitetura}

Fonte: Autor.
"""
  Dado eu executo `pandoc -t latex figura.md -o figura-pandoc.tex`
  Então o arquivo "figura-pandoc.tex" deve conter:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

\begin{figure}
\hypertarget{arquitetura}{%
\centering
\includegraphics{limarka-arquitetura.jpg}
\caption{Arquitetura do Limarka}\label{arquitetura}
}
\end{figure}

Fonte: Autor.
"""
