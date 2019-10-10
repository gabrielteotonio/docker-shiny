## First things first!  
Join the [Rstudio community](https://community.rstudio.com/) and share the knowledge!  

## 1. Installing Docker

### Ubuntu
```
sudo apt-get install docker.io
```
### Fedora
```
sudo dnf installl docker
``` 
### Mac os
See the following guide: [Mac installation](https://docs.docker.com/v17.12/docker-for-mac/install/)

### Windows
See the following guide: [Windows installation](https://runnable.com/docker/install-docker-on-windows-10)

## 2. Share your code analysis
Code reproducibility is a great bottleneck in many ways. Can be when you want to share your work with a colleague or a journal editor is trying to reproduce your results to make sure you did well. 

### R

Let's first run R inside a container. 

```
docker run  --rm --name=rgui -it r-base 
```

The options selected:  
```rm```: automatically remove the container when it exits;  
```name```: assign a name to the container;  
```it```: create a interactive terminal to acess the container.  

Now you have R running in your terminal without do installation of R into your machine.  

### Rstudio  

Rstudio is the IDE for most of R users and we can also run it using Docker!

```
docker run -e USER=fisher -e PASSWORD=kolmogorov --rm -d -p 8787:8787 rocker/rstudio:3.5.2
```
The ```-e``` creates environment variables. Here, we have created the credentials to acess the Rstudio server.  

### Running your analysis inside a container


First create a folder for your analysis and Dockerfile  
```
mkdir analysis
cd analysis
touch my_analysis.R
touch Dockerfile
```

And let's put some content in the analysis file:  
```
library(tidyr)
library(dplyr)

data("population")
pop_per_country <- population %>% 
                      group_by(country) %>% 
                      summarise(population = sum(population)) %>% 
                      arrange(desc(population))

write.csv(pop_per_country, "pop_per_country.csv")
```
And our Dockerfile would be:  
```
FROM rocker/r-ver:3.5.3

ARG WHEN

RUN mkdir /home/analysis

RUN R -e "options(repos = \
  list(CRAN = 'https://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('tidyr'); \
  install.packages('dplyr');"
  
COPY my_analysis.R /home/analysis

CMD cd /home/analysis \
  && R -e "source('my_analysis.R')" 
```

As you can see, we do some commands in the Dockerfile to make possible our analysis to run.  
In ```FROM rocker/r-ver:3.5.3``` we defined from which image we are going to build ours over. The ```ARG``` creates a environment variable, and with this we hav created the variable ```WHEN``` that will set the date for getting the packages from R cran.  
Now we create a directory in the container system where we are going to copy our analysis file. As this container is a new process that just started and the image we used as base only brings a OS based on debian and R installed, we have to install the packages that are required in ```my_analysis.R```.  
Once we have all the requirements installed, let's copy our ```my_analysis.R``` to container and finally build it!  
The following command builds our image using the Docker file as a template of instructions.    
```
docker build --build-arg WHEN=2019-05-29 -t gabrielteotonio/analysis:0.1 .
```
Let's run a container using this image we have created:  
```
docker run --rm --name=my_analysis gabrielteotonio/analysis:0.1
```

Awesome! You just run your analysis in a isolated environment. But almost surely you will want to have the results of your analysis, i.e. outside your container, to see how it was performated. To solve it, we need to create a folder inside the container that will be persisted to another folder in the host machine. For this, we use the flag ```-v``` when running the container, with ```/path/from/host:/path/in/conatiner``` that will map the folder inside the container to the folder on host machine.  
The Dockerfile needs to be updated to create a folder to put the results of ```my_analysis.R``` .  

```
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
```
After build the image using another tag, run the container with the ```-v``` flag mapping the folders.  
```
docker run --rm -v /home/gabriel.teotonio/Documents/code/docker-shiny/analysis_example/results:/home/results gabrielteotonio/analysis:0.2
```

Previously we have ran a container with Rstudio, now you can add a volume to that structure to save your analysis results when finished as we did with R container.  

## 3. Shiny app and Docker

Reliability is one of our main objectives when we deploy services in production. We can face a lot of problems when deploying our applications. In the Shiny app case, in particular, similar analysis can lead to slightly different results. As we saw, Docker is a solution for this problem.  
For this tutorial, consider the image compression app.  

The app brings PCA (Principal Component Anaysis) for image compression. We can see how the compression is performated for different numbers of principal components.  
The dockerfile:

```
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
```

The Dockerfile follows the same structure as analysis example. The ```FROM quantumobject/docker-shiny``` defined from which image we are going to build ours over. The ```RUN``` command below install some dependencies necessaries for R packages. As we did previously, the installation of R packages is done by ```RUN R -e```.  In ```EXPOSE 3838```, we say to container which port it'll publish the app.  

Let's build!  
```docker build -t gabrielteotonio/app:0.1 .```  

Running the container:  
```docker run --rm -d -p 3838:3838 gabrielteotonio/app:0.1```

## Go further and make more: some references for your journey using Shiny  
- [Rstudio articles](https://shiny.rstudio.com/articles/)  
- [curso-r material (PT)](https://www.curso-r.com/material/shiny/)  
- [Shinydashboard layout tutorial](https://rstudio.github.io/shinydashboard/)  
- [Docker: get started](https://docs.docker.com/get-started/)  
- [Shiny in production book](https://kellobri.github.io/shiny-prod-book/)  
- [Best practices database connections in Shiny apps](https://db.rstudio.com/best-practices/dashboards)  
- [Database using dplyr](https://db.rstudio.com/dplyr/)  
- [Shiny cheat sheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
