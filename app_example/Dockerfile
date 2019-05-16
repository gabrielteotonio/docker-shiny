FROM quantumobject/docker-shiny

RUN apt-get update \ 
    && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev libpq-dev \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('EMD')"
RUN R -e "install.packages('blockmatrix')"

RUN rm -rf /srv/shiny-server/*

COPY ./app_image_comp /srv/shiny-server

EXPOSE 3838

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"] 