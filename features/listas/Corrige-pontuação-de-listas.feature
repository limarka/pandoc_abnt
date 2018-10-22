# language: en
Feature: Automaticamente corrige pontuações de listas

    Segundo as normas da ABNT todos os ítens das listas devem terminar com
    ponto e vírgula (`;`) e apenas o último ítem deve terminar com ponto final
    (`.`).

Scenario: Adicionando pontuações
  Given a file named "texto.md" with:
"""
a) item 1
b) item 2
c) item 3
"""
  When I run `pandoc -t plain --filter pandoc_abnt texto.md -o texto.txt`
  Then the file named "texto.txt" should contain:
"""
a)  item 1;
b)  item 2;
c)  item 3.
"""

Scenario: Corrigindo pontuações erradas (tudo terminando com ponto final)
  Given a file named "texto.md" with:
"""
a) item 1.
b) item 2.
c) item 3.
"""
  When I run `pandoc -t plain --filter pandoc_abnt texto.md -o texto.txt`
  Then the file named "texto.txt" should contain:
"""
a)  item 1;
b)  item 2;
c)  item 3.
"""

Scenario: Corrigindo pontuações erradas (tudo terminando com ponto e vírgula)
  Given a file named "texto.md" with:
"""
a) item 1;
b) item 2;
c) item 3;
"""
  When I run `pandoc -t plain --filter pandoc_abnt texto.md -o texto.txt`
  Then the file named "texto.txt" should contain:
"""
a)  item 1;
b)  item 2;
c)  item 3.
"""
