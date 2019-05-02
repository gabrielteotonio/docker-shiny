<p float="middle">
<img src="https://community.rstudio.com/uploads/default/original/1X/c017cef9c13bc937df73659d3b5b1411a39c7ed2.png" alt="drawing" width="270"/>
<img src="https://www.docker.com/sites/default/files/social/docker_facebook_share.png" alt="drawing" width="350"/>
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

## 2. R

Let's first run R inside a container. 

```
docker run  --rm --name=rgui -it r-base 
```

The options selected:  
rm: automatically remove the container when it exits;  
name: assign a name to the container;  
it: create a interactive terminal to acess the container.  

<img src="https://drive.google.com/uc?export=view&id=1mpQFZ-xxc2u50sbvluXqH-QE5qh9BQ-e" alt="drawing" width="400"/>

Now you have R running in your terminal without do installation of R into your machine.  

## 3. Running Rstudio inside a container

Rstudio is the IDE for most of R users and we can also run it using Docker!

```
docker run -e USER=fisher -e PASSWORD=kolmogorov --rm -d -p 8787:8787 rocker/rstudio:3.5.2
```

## 4. Shiny app and Docker

Reliability is our main objective when we deploy services in production. Imagine you are working on an analysis in R and you send your code to a friend. Your friend runs exactly this code on exactly the same dataset but receives a slightly different result. This can have various reasons such as a different operating system or a different version of an R package. A solution for this problem is Docker!
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. In a way, Docker is a bit like a virtual machine. But unlike a virtual machine, rather than creating a whole virtual operating system, Docker allows applications to use the same Linux kernel as the system that they're running on and only requires applications be shipped with things not already running on the host computer. This gives a significant performance boost and reduces the size of the application. Using docker is a great way to deploy a Shiny application.
