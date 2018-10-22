# language: pt
Funcionalidade: Automaticamente corrige pontuações de listas

    Segundo as normas da ABNT todos os ítens das listas devem terminar com
    ponto e vírgula (`;`) e apenas o último ítem deve terminar com ponto final
    (`.`).

Cenário: Adicionando pontuações
  Dado um arquivo chamado "texto.md" contendo:
"""
a) item 1
b) item 2
c) item 3
"""
  Dado eu executo `pandoc -t plain --filter pandoc_abnt texto.md -o texto.txt`
  Então o arquivo "texto.txt" deve conter:
"""
a)  item 1;
b)  item 2;
c)  item 3.
"""

Cenário: Corrigindo pontuações erradas (tudo terminando com ponto final)
  Dado um arquivo chamado "texto.md" contendo:
"""
a) item 1.
b) item 2.
c) item 3.
"""
  Dado eu executo `pandoc -t plain --filter pandoc_abnt texto.md -o texto.txt`
  Então o arquivo "texto.txt" deve conter:
"""
a)  item 1;
b)  item 2;
c)  item 3.
"""

Cenário: Corrigindo pontuações erradas (tudo terminando com ponto e vírgula)
  Dado um arquivo chamado "texto.md" contendo:
"""
a) item 1;
b) item 2;
c) item 3;
"""
  Dado eu executo `pandoc -t plain --filter pandoc_abnt texto.md -o texto.txt`
  Então o arquivo "texto.txt" deve conter:
"""
a)  item 1;
b)  item 2;
c)  item 3.
"""
