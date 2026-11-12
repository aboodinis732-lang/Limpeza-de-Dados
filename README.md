# Limpeza de Dados em R

Projecto de limpeza do ficheiro `dados_sujos_limpeza.csv` (125 registos de vendas) usando R.

## Ficheiros

| Ficheiro | Descrição |
|---|---|
| `dados_sujos_limpeza.csv` | Dados originais (com erros) |
| `limpeza_dados.R` | Script de limpeza |
| `dados_limpos.csv` | Resultado final, gerado pelo script |

## Como executar

1. Colocar o script e o CSV na mesma pasta.
2. Abrir `limpeza_dados.R` no RStudio.
3. Executar o script completo (Ctrl + Shift + Enter).
4. O ficheiro `dados_limpos.csv` é criado na mesma pasta.

## Passos realizados

1. **Importar** o ficheiro com `read.csv()`, tratando o BOM do UTF-8 e células vazias como `NA`.
2. **Valores ausentes:** identificados com `is.na()` e `colSums()`. Idade e preço foram preenchidos com a mediana; cidade e email ficaram em branco.
3. **Duplicados:** removidos com `duplicated()` (5 registos).
4. **Espaços e maiúsculas/minúsculas:** padronizados em `produto`, `cidade` e `metodo_pagamento`.
5. **Outliers:** idades impossíveis (-5 e 250), quantidade negativa e satisfação fora da escala 1–5 foram convertidas em `NA`; preços verificados pelo método IQR.
6. **Tipos de dados:** preços com vírgula decimal convertidos para numérico; datas em vários formatos convertidas para `Date`.
7. **Emails:** validados com expressão regular; os inválidos ficaram em branco.
8. **Exportar** o resultado com `write.csv()` para `dados_limpos.csv`.

## Colunas

`id_venda`, `nome_cliente`, `idade`, `cidade`, `produto`, `quantidade`, `preco_unitario_MZN`, `data_venda`, `email`, `metodo_pagamento`, `satisfacao`, `email_valido`

## Autores

Grupo de trabalho — Licenciatura em Estatística, Monitoria e Avaliação.
