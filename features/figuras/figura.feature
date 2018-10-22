# language: en
Feature: Figuras
    Segundo as normas da ABNT todas as figuras devem ser adicionadas
    com um título em cima, e a fonte em baixo. E depois ela deve ser
    referenciada no texto o mais próximo possível. **Nenhuma figura
    pode ser inserida no texto sem ser referenciada**.

Scenario:: Funcionamento normal do pandoc (sem pandoc_abnt)
  Given a file named "figura.md" with:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

![Arquitetura do Limarka](limarka-arquitetura.jpg){#arquitetura}

Fonte: Autor.
"""
  When I run `pandoc -t latex figura.md -o figura-pandoc.tex`
  Then the file named "figura-pandoc.tex" should contain:
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

Scenario:: Utilizando pandoc com o filtro pandoc_abnt
  Given a file named "figura.md" with:
"""
A arquitetura do Limarka (ver \autoref{arquitetura}) é composto por um
processador de formulário PDF, um template baseado no abntex2 e um
filtro pandoc-abnt.

![Arquitetura do Limarka](limarka-arquitetura.jpg){#arquitetura}

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
\includegraphics{limarka-arquitetura.jpg}
\end{center}
}
\legend{Fonte: Autor.}
\end{figure}
"""

Scenario:: Utilizando figura com parâmetro escala
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
