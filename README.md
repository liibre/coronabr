# Download de dados do coronavírus no Brasil

__coronabr__ é um pacote de [R](https://www.r-project.org/) para fazer download e visualizar os dados dos casos diários de coronavírus (COVID-19) disponibilizados por diferentes fontes:

- [Ministério da Saúde](http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil);
- [Brasil em dados libertos](https://brasil.io/dataset/covid19/caso);
- [Johns Hopkins University](https://github.com/CSSEGISandData/COVID-19)

Antes de mais nada, declaramos nossa postura alinhada com as ideias de uma ciência de dados responsável, compromissada e feminista. Somos alinhadxs com o [manifest-no](https://www.manifestno.com/), refutamos regimes de dados prejudiciais e nos comprometemos a novos futuros de dados.
Apesar de acreditarmos no acesso sem distinção a dados abertos, não recomendamos que toda análise que possa ser feita o seja. Ao se tratar de uma situação de saúde pública delicada, visualizações, extrapolações, e predições devem ser feitas com todo cuidado, lembrando que a qualidade dos dados é incerta e que todo dado diz respeito a uma pessoa. No Brasil, a notificação de casos carrega consigo vieses espaciais, econômicos e de classe que não podem ser ignorados. Para uma previsão a curto prazo do crescimento no número de casos veja [aqui](https://covid19br.github.io/index.html) (portal de **qualidade** um grupo colaborativo de cientistas brasileirxs).

O código é aberto. Entre em [como usar](https://liibre.github.io/coronabr/articles/coronabr.html) para um exemplo de como utilizar o pacote. Compartilhe. 

- A partir de 14/03/20, a notificação de casos graves de covid-19 foca apenas nos casos graves que são atendidos nos hospitais.
- A partir de 18/03/2020, a página original do Min. da Saúde parou de funcionar e os boletins estão sendo divulgados em apresentações de powerpoint e PDFs. [Adriano Belisario](www.twitter.com/belisards) está fazendo a compilação manual destes dados [aqui](https://github.com/belisards/coronabr)
<!--- A partir de 20/03/2020, a notificação exclui os casos suspeitos que vinham sendo divulgados.-->


Disponibilizamos aqui atualizações diárias dos gráficos. Sabemos que deve haver maneiras responsáveis de apresentar estes dados e que as comparações entre regiões e países dependem de muitas variáveis.

Fazemos ciência aberta, democrática e reprodutível. Este é um trabalho em desenvolvimento. Sugestões, entrem em contato conosco. <!---  Para entender como contribuir, clique [aqui](). -->

**ATENÇÃO:** O site do Min. da Saúde está em manutenção. Última atualização em 18/03/2020. Função `get_corona()` sem retorno. Veja `get_corona_br()` ou `get_corona_jhu()`. 

## Crescimento nacional no número de casos

<img src="https://raw.githubusercontent.com/liibre/coronabr/master/docs/articles/graficos_files/figure-html/fig-casos-1.png" align="center" alt="" width="600" />


## Entendendo o aumento diário

<img src="https://raw.githubusercontent.com/liibre/coronabr/master/docs/articles/graficos_files/figure-html/fig-perc-1.png" align="center" alt="" width="600" />

## Número de casos por estado brasileiro

<img src="https://raw.githubusercontent.com/liibre/coronabr/master/docs/articles/graficos_files/figure-html/mapa1-1.png" align="center" alt="" width="600" />

## Crescimento do número de casos nos estados mais afetados

<img src="https://raw.githubusercontent.com/liibre/coronabr/master/docs/articles/graficos_files/figure-html/estados-1.png" align="center" alt="" width="600" />

## Evolução do número de casos por estado

<img src="https://raw.githubusercontent.com/liibre/coronabr/master/vignettes/figs/anim.gif" align="center" alt="" width="600" />

## Para saber mais:

- Dados compilados pelo [Álvaro Justen](https://github.com/turicas/) e colaboradores [aqui](https://brasil.io/dataset/covid19/caso)

- [John Hopkins Coronavirus COVID-19 Global Cases](https://coronavirus.jhu.edu/map.html)

- [Observatório Covid-19 BR](https://covid19br.github.io/)

- [covid19br](https://paternogbc.github.io/covid19br/index.html), o pacote de R [Gustavo Palermo](https://github.com/paternogbc) para acompanhar os dados de novos casos no Brasil


- [Portal da Fiocruz](https://portal.fiocruz.br/coronavirus)

- [Site oficial da Organização Mundial da Saúde (em inglês)](https://www.who.int/emergencies/diseases/novel-coronavirus-2019)

- [Tira dúvidas do Instituto Butantan](http://coronavirus.butantan.gov.br/)

- [Banco de dados aberto COVID-19 (em inglês)](https://pages.semanticscholar.org/coronavirus-research])

- [Atualização mundial do número de casos](https://www.worldometers.info/coronavirus/)

- [Dez considerações antes de criar mais um gráfico sobre o COVID-19 (em inglês)](https://medium.com/nightingale/ten-considerations-before-you-create-another-chart-about-covid-19-27d3bd691be8)

- Siga o **Atila Iamarino** no [youtube](https://www.youtube.com/channel/UCSTlOTcyUmzvhQi6F8lFi5w), [Instagram](www.instagram.com/oatila), [twitter](https://twitter.com/oatila) ou [telegram](https://t.me/corona_atila). Tem também um [fórum brasileiro de reddit](https://www.reddit.com/r/coronabr/) com muita informação.

Dúvidas, contribuições e sugestões, poste uma *issue* [aqui](https://github.com/liibre/coronabr/issues) ou nos encontre no twitter ( [Sara](https://twitter.com/mortarasara), [Andrea](https://twitter.com/SanchezTapiaA) ou [Karlo]() ).
