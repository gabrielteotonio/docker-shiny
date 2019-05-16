FROM rocker/r-ver:3.5.3

ARG WHEN

RUN mkdir /home/analysis

RUN R -e "options(repos = \
  list(CRAN = 'https://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('tidyr'); \
  install.packages('dplyr');"
  
COPY my_analysis.R /home/analysis

RUN mkdir /home/results

CMD cd /home/analysis \
  && R -e "source('my_analysis.R')" \
  && mv /home/analysis/pop_per_country.csv /home/results/pop_per_country.csv 