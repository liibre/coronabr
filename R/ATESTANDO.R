remotes::install_github("liibre/coronabr")

library(coronavirus)
data(coronavirus)
coronavirus
summary(coronavirus)

library(coronabr)
dados <- get_corona_br(by_uf = TRUE)
head(dados)
dados_jhu <- get_corona_jhu()


head(dados_jhu)
help(dados_jhu)
?dados_jhu

table(dados_jhu$country_region)

library(dplyr)
dados_jhu %>%
  group_by()

dados_jhu[dados_jhu$country_region == 'Brazil', ]

library(data.table)
as.tiv(dados1)


head(dados1)
head(dados2)

plot(sort(dados1$date))
plot(na.omit(sort(dados2$data)))
dados2[dados2$estado=='CE',]

library(gridExtra)
a1 <- plot_corona_br(dados1)
a2 <- plot_corona_minsaude(dados2)

a3 <- plot_corona_br(dados1, tipo = 'aumento')
a4 <- plot_corona_minsaude(dados2, tipo = 'aumento')
gridExtra::grid.arrange(a1,
                        a2, ncol=1)
gridExtra::grid.arrange(a3,
                        a4, ncol=1)

