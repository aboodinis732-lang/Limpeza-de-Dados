# Limpeza de dados - dados_sujos_limpeza.csv
# Coloque este script na mesma pasta do CSV (ou use setwd()).

# 1. Importar o ficheiro
dados <- read.csv("dados_sujos_limpeza.csv",
                  fileEncoding = "UTF-8-BOM",
                  stringsAsFactors = FALSE,
                  na.strings = c("", "NA"))
str(dados)
cat("Linhas iniciais:", nrow(dados), "\n")

# 2. Identificar valores ausentes
colSums(is.na(dados))
sum(!complete.cases(dados))

# 3. Eliminar registos duplicados
cat("Duplicados:", sum(duplicated(dados)), "\n")
dados <- dados[!duplicated(dados), ]

# 4. Corrigir espaços e maiúsculas/minúsculas
dados$produto <- tools::toTitleCase(tolower(trimws(dados$produto)))
dados$cidade  <- tools::toTitleCase(tolower(trimws(dados$cidade)))
dados$cidade  <- gsub("Xai-xai", "Xai-Xai", dados$cidade)

pag <- tolower(trimws(dados$metodo_pagamento))
dados$metodo_pagamento <- c("m-pesa"  = "M-Pesa",
                            "e-mola"  = "e-Mola",
                            "cartão"  = "Cartão",
                            "dinheiro" = "Dinheiro")[pag]

# 6. Corrigir tipos de dados (antes dos outliers, para poder calcular)
# preços com vírgula decimal ("36519,66") -> ponto
dados$preco_unitario_MZN <- as.numeric(gsub(",", ".", dados$preco_unitario_MZN))
dados$idade        <- as.numeric(dados$idade)
dados$quantidade   <- as.numeric(dados$quantidade)
dados$satisfacao   <- as.numeric(dados$satisfacao)

# datas em vários formatos; as inválidas (ex.: 31/14/2025) ficam NA
d <- trimws(dados$data_venda)
dados$data_venda <- as.Date(d, format = "%Y-%m-%d")
f2 <- as.Date(d, format = "%d-%m-%Y")
f3 <- as.Date(d, format = "%d/%m/%Y")
dados$data_venda[is.na(dados$data_venda)] <- f2[is.na(dados$data_venda)]
dados$data_venda[is.na(dados$data_venda)] <- f3[is.na(dados$data_venda)]

# 5. Identificar e tratar outliers
# 5a. valores impossíveis -> NA
dados$idade[dados$idade < 0 | dados$idade > 100]           <- NA
dados$quantidade[dados$quantidade <= 0]                    <- NA
dados$satisfacao[dados$satisfacao < 1 | dados$satisfacao > 5] <- NA

# 5b. método IQR para o preço (apenas para identificar)
q   <- quantile(dados$preco_unitario_MZN, c(.25, .75), na.rm = TRUE)
iqr <- q[2] - q[1]
out <- which(dados$preco_unitario_MZN < q[1] - 1.5 * iqr |
             dados$preco_unitario_MZN > q[2] + 1.5 * iqr)
cat("Outliers de preço (IQR):", length(out), "\n")
boxplot(dados$idade, main = "Idade")

# Tratar valores ausentes: idade e preço -> mediana
dados$idade[is.na(dados$idade)] <-
  median(dados$idade, na.rm = TRUE)
dados$preco_unitario_MZN[is.na(dados$preco_unitario_MZN)] <-
  median(dados$preco_unitario_MZN, na.rm = TRUE)

# 7. Validar emails
dados$email <- tolower(trimws(dados$email))
padrao <- "^[[:alnum:]._-]+@[[:alnum:].-]+\\.[a-z]{2,}$"
dados$email_valido <- grepl(padrao, dados$email)   # NA vira FALSE
dados$email[!dados$email_valido] <- NA

# 8. Guardar o CSV limpo
write.csv(dados, "dados_limpos.csv", row.names = FALSE, na = "")
cat("Linhas finais:", nrow(dados), "\n")
