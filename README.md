# Using Shiny application with Docker

Reliability is our main objective when deploy services in production. Imagine you are working on an analysis in R and you send your code to a friend. Your friend runs exactly this code on exactly the same data set but gets a slightly different result. This can have various reasons such as a different operating system, a different version of an R package. A solution for this problem is Docker!
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. In a way, Docker is a bit like a virtual machine. But unlike a virtual machine, rather than creating a whole virtual operating system, Docker allows applications to use the same Linux kernel as the system that they're running on and only requires applications be shipped with things not already running on the host computer. This gives a significant performance boost and reduces the size of the application. Docker seems a great way for us to deploy a Shiny application.

## 1. Installing Docker

### Ubuntu
```
sudo apt-get install docker.io
```
### Fedora
```
sudo dnf installl docker
``` 

## 2. Running R inside a container


```
docker run  --rm --name=rgui -it r-base 
```
  
## 3. Running Rstudio inside a container

Rstudio is the IDE for most of R users andwe can also run it using Docker!

```
docker run -e USER=fisher -e PASSWORD=kolmogorov --rm -d -p 8787:8787 rocker/rstudio:3.5.2
```

## 4. Shiny app and Docker