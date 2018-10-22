# language: pt
Funcionalidade: Inserir figura conforme as normas da ABNT
    Segundo as normas da ABNT todas as figuras devem ser adicionadas
    com um título em cima, e a fonte em baixo. E depois ela deve ser
    referenciada no texto o mais próximo possível. **Nenhuma figura
    pode ser inserida no texto sem ser referenciada**.

    Esse filtro permite a inclusão de figuras, especificando a sua fonte
    em baixo e posiciona a figura na página mais próximo do local esperado.
    Para referenciar no texto, basta utilizar o comando latex corespondente
    (tal como `\autoref`).

Cenário: Incluindo uma figura com título e fonte
  Dado um arquivo chamado "figura.md" contendo:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

![Arquitetura do Limarka](limarka-arquitetura.jpg){#arquitetura}

Fonte: Autor.
"""
  Dado eu executo `pandoc -t latex --filter pandoc_abnt figura.md -o figura-pandoc_abnt.tex`
  Então o arquivo "figura-pandoc_abnt.tex" deve conter:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

\begin{figure}[htbp]
\hypertarget{arquitetura}{%
\caption{Arquitetura do Limarka}\label{arquitetura}
\begin{center}
\includegraphics{limarka-arquitetura.jpg}
\end{center}
}
\legend{Fonte: Autor.}
\end{figure}
"""
