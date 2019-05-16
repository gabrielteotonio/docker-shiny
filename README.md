<p float="middle">
<img src="https://drive.google.com/uc?export=view&id=1w5GsJJNpJMSzQ667jPYseFRzlNI6325-" alt="drawing" width="450"/>
</p>


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
See the following guide: ![Mac installation](https://docs.docker.com/v17.12/docker-for-mac/install/)

### Windows
See the following guide: ![Windows installation](https://runnable.com/docker/install-docker-on-windows-10)

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

<img src="https://drive.google.com/uc?export=view&id=1mpQFZ-xxc2u50sbvluXqH-QE5qh9BQ-e" alt="drawing" width="500"/>

Now you have R running in your terminal without do installation of R into your machine.  

### Rstudio  

Rstudio is the IDE for most of R users and we can also run it using Docker!

```
docker run -e USER=fisher -e PASSWORD=kolmogorov --rm -d -p 8787:8787 rocker/rstudio:3.5.2
```

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
Once we have all the requirements installed, let's copy our ```my_analysis.R``` to container and finally run it!

```
docker run --rm -v /home/gabriel.teotonio/Documents/code/docker-shiny/analysis_example/results:/home/results gabrielteotonio/analysis:0.1
```

## 3. Shiny app and Docker

Reliability is our main objective when we deploy services in production. Imagine you are working on an analysis in R and you send your code to a friend. Your friend runs exactly this code on exactly the same dataset but receives a slightly different result. This can have various reasons such as a different operating system or a different version of an R package. A solution for this problem is Docker!  
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. In a way, Docker is a bit like a virtual machine. But unlike a virtual machine, rather than creating a whole virtual operating system, Docker allows applications to use the same Linux kernel as the system that they're running on and only requires applications be shipped with things not already running on the host computer. This gives a significant performance boost and reduces the size of the application. Using docker is a great way to deploy a Shiny application.