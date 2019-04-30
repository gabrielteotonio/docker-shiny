FROM quantumobject/docker-shiny

RUN apt-get update \ 
    && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev libpq-dev \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('tidyverse')"


RUN rm -rf /srv/shiny-server/*

COPY . /srv/shiny-server

#volume for Shiny Apps and static assets. Here is the folder for index.html (link) and sample apps.
#VOLUME /srv/shiny-server

# to allow access from outside of the container to the container service
# at the ports to allow access from firewall if accessing from outside the server. 
EXPOSE 3838

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"] 
