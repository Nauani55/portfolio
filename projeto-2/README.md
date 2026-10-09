# Vende Mais: Dashboard de Vendas e Devoluções

Dashboard interativo em **Power BI** que analisa as vendas e as devoluções de uma rede de 13 lojas entre 2017 e 2018. O relatório está organizado como uma narrativa (storytelling): começa com a visão geral, passa por vendas, devoluções e produtos, e termina com conclusões e recomendações.

> Projeto desenvolvido no âmbito da UC 10803 Análise Avançada de dados, sob orientação da formadora Vânia Sofia Ferreira.
---

## Objetivo

Responder, de forma visual e apresentável, a quatro perguntas de gestão:

1. **Como estamos?** Faturação, meta mensal e taxa de devoluções.
2. **Onde e quando vendemos?** Lojas, cidades e evolução entre anos.
3. **O que estamos a perder?** Devoluções por mês, loja e produto.
4. **O que sustenta a receita?** Marcas e produtos-estrela.

## Principais números

| Indicador | Valor |
|---|---|
| Total faturado | 131,22 M€ |
| Nº de vendas | 19.785 |
| Ticket médio | 6.632,30 € |
| Lojas | 13 |
| Produtos devolvidos | 2.037 |
| Taxa de devoluções (global) | 3,43% (limite definido: 5%) |
| Faturação 2017 / 2018 | 64,9 M€ / 66,3 M€ |

## Estrutura do relatório

| Página | Pergunta | Conteúdo |
|---|---|---|
| **Início** | Por onde começar? | Página de entrada e navegação |
| **Geral** | Como estamos? | KPIs, meta de faturação mensal, taxa de devoluções, medidores de faturação e devoluções, faturação por loja e evolução por trimestre |
| **Vendas** | Onde e quando vendemos? | Nº de vendas, ticket médio, loja líder e com menos vendas, lojas-estrela, mapa por cidade, ranking de lojas, faturação 2017 vs 2018 |
| **Devoluções** | O que estamos a perder? | Produtos mais e menos devolvidos, taxa de devoluções, % de devolução por loja, índice mensal com linha de limite de 5%, detalhe por produto |
| **Marcas/Produtos** | O que sustenta a receita? | Produto mais e menos vendido, marca líder, produtos-estrela, peso dos 5 produtos principais, faturação e % de devolução por produto |


**Interatividade**
- Filtros de marca, produto, mês e ano em todas as páginas.
- Botão de limpar filtros e menu de navegação entre páginas.
- Parâmetros de simulação (*Aumento de faturação* e *Máx devoluções*).
- Seleção de período (ano, dia, dia da semana, nome do mês, trimestre) e de valor a analisar.

## Modelo de dados

| Tabela | Tipo | Descrição |
|---|---|---|
| `Vendas` | Factos | Registo das vendas |
| `Devolucoes` | Factos | Registo das devoluções |
| `Lojas` | Dimensão | Dados das lojas |
| `Produtos` | Dimensão | Produtos e marcas |
| `Calendario` | Dimensão | Datas, anos, trimestres e meses |
| `Vendas por Loja` | Auxiliar | Vendas agregadas por loja |
| `Resumo lojas`, `Resumo lojas por ano` | Calculadas | Resumos por loja e por ano |
| `Ranking das lojas` | Calculada | Posição das lojas por faturação |
| `Top5 Lojas Vendas`, `Top5 Lojas Vendas por Ano` | Calculadas | Cinco lojas com mais vendas |
| `Medidas` | Medidas | Tabela que agrupa as medidas DAX |

## Medidas DAX

Exemplos das medidas usadas. Os nomes das colunas devem ser adaptados ao modelo.

```dax
-- Ticket médio
Ticket Médio = DIVIDE([Total Faturado], [Nº de Vendas])

-- Variação face ao ano anterior (só com um ano selecionado)
Var % vs Ano Anterior =
VAR AnoAtual = SELECTEDVALUE(Calendario[Ano])
VAR FatAtual = [Total Faturado]
VAR FatAnterior = CALCULATE([Total Faturado], Calendario[Ano] = AnoAtual - 1)
RETURN
IF(
    ISBLANK(AnoAtual) || ISBLANK(FatAnterior),
    BLANK(),
    DIVIDE(FatAtual - FatAnterior, FatAnterior)
)

-- Ranking de lojas
Ranking Loja =
RANKX(ALLSELECTED(Lojas[Nome da Loja]), [Total Faturado], , DESC, DENSE)

-- Peso das 3 lojas principais
% Top 3 Lojas =
VAR Top3 = TOPN(3, ALLSELECTED(Lojas[Nome da Loja]), [Total Faturado], DESC)
RETURN
DIVIDE(
    CALCULATE([Total Faturado], Top3),
    CALCULATE([Total Faturado], ALLSELECTED(Lojas[Nome da Loja]))
)

-- Ranking de produtos e peso dos 5 produtos principais
Ranking Produto =
RANKX(ALLSELECTED(Produtos[Nome do Produto]), [Total Faturado], , DESC, DENSE)

% Top 5 =
VAR Top5 = TOPN(5, ALLSELECTED(Produtos[Nome do Produto]), [Total Faturado], DESC)
RETURN
DIVIDE(
    CALCULATE([Total Faturado], Top5),
    CALCULATE([Total Faturado], ALLSELECTED(Produtos[Nome do Produto]))
)

-- Cor condicional das barras dos produtos-estrela
Cor Barra = IF([Ranking Produto] <= 5, "#1E90FF", "#A9C7DD")

-- Marca líder
Marca Líder =
VAR Lider = TOPN(1, ALLSELECTED(Produtos[Marca]), [Total Faturado], DESC)
RETURN MAXX(Lider, Produtos[Marca])

-- Taxa de devolução (em unidades)
Nº de devoluções = SUM(Devolucoes[Quantidade D])
% devolvidos = DIVIDE([Nº de devoluções], SUM(Vendas[Quantidade]))
```

## Design e identidade visual

A paleta foi mantida em todas as páginas, com uma função clara para cada cor:

| Cor | Hex | Utilização |
|---|---|---|
| Azul-petróleo | `#1788AE` | Cabeçalho, títulos dos cartões |
| Azul vivo | `#1E90FF` | Dado principal em destaque (Top da faturação) |
| Azul-acinzentado | `#A9C7DD` | Restantes valores |
| Azul escuro | `#0E4A5E` | Elementos de apoio |
| Verde / vermelho | `#1E8E3E` / `#C0392B` | Apenas para meta cumprida / não cumprida |

**Princípios aplicados**
- Mesma estrutura em todas as páginas: cabeçalho, filtros, KPIs, gráfico principal e detalhe.
- Um destaque por gráfico (barras azul vivo para o Top, azul-acinzentado para o resto).
- Títulos claros e unidades em todos os valores (M€, %, un.).
- Linha constante de 5% no gráfico mensal de devoluções para mostrar o limite.
- Rótulos legíveis e gráficos de barras horizontais para nomes longos.

## Principais conclusões

- **Crescimento modesto:** a faturação passou de 64,9 M€ (2017) para 66,3 M€ (2018), cerca de +2%, e a meta mensal está praticamente no limite.
- **Concentração nas lojas:** São Paulo faturou 30,55 M€ (cerca de 23% do total) e as 3 lojas principais somam 44,63%.
- **Concentração nos produtos:** os 5 produtos principais geram 45,97% da faturação, com a Smart TV 50" 4K e o iPhone XS à cabeça.
- **Marca líder:** a Samsung, com 29,22 M€ e 24 produtos.
- **Devoluções sob controlo, com picos:** a taxa global (3,43%) está abaixo do limite de 5%, mas fevereiro e junho ultrapassam-no e outubro fica no limite.
- **Lojas com mais devoluções:** Nova Iguaçu, Niterói e Campinas, com valores entre 8% e 9%.
- **Produtos-estrela fiáveis:** têm taxas de devolução baixas, ao contrário do iPad 32GB Wifi Prata, que é o produto mais devolvido.

**Recomendações**
1. Investigar as devoluções nas lojas acima do limite (qualidade, entrega ou atendimento).
2. Rever o iPad 32GB Wifi Prata (preço, descrição ou permanência no catálogo).
3. Replicar as práticas de São Paulo nas lojas mais pequenas, reduzindo a dependência das três lojas principais.



## Autora

Nauani Dias

**Orientação:**
Vânia Sofia

---

*Projeto académico. Os dados utilizados destinam-se exclusivamente a fins de aprendizagem.*
