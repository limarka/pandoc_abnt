**Quadros** e **Tabelas** são elementos utilizados em trabalhos acadêmicos, e possuem diferenças e especificações definidas pela ABNT.

As **Tabelas** são formadas por linhas verticais, devem manter suas bordas laterais abertas e geralmente são utilizadas para **dados quantitativos**.

Os **Quadros**, por outro lado, são formados por linhas verticais e horizontais, devem ter todas suas extremidades fechadas e são mais utilizados para
**dados qualitativos**.

Ambos devem **possuir título, fonte e serem referenciados no texto**.

## A sintaxe de tabelas ou quadros em Markdown

O pandoc não faz distinção entre tabelas e quadros, chama tudo de tabela e [apresenta as sintaxes disponíveis na sua documentação](http://pandoc.org/MANUAL.html#tables). No entanto, nenhuma das sintaxes apresentadas permite a inclusão da Fonte do elemento.

Para possibilitar a elaboração desses elementos seguindo as normas da ABNT, essa extensão cria uma notação que permite a inclusão da fonte, basta para isso adicionar um parágrafo após o elemento iniciando com `Fonte: `.
