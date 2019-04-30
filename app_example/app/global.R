# Packages ----
library(shiny)
library(EMD) # Lena's image
library(blockmatrix) # For creating block matrices
library(ggplot2) # Graphics

# Loading data ----
data(lena) # Storage the image

# Functions ----
blockToObs <- function(block_matrix) {
  obs_matrix <- c()
  for (i in 1:64) {
    for (j in 1:64) {
      obs <- as.vector(t(block_matrix[i,j]))
      obs_matrix <- rbind(obs_matrix, obs)
    }  
  }
  return(obs_matrix)
}

obsToBlock <- function(Obs_matrix) {
  matrix <- matrix(0, nrow = 512, ncol = 512) 
  cont <- 1
  for (i in seq(1,512,8)) {
    for (j in seq(1,512,8)) {
      block_matrix <- matrix(Obs_matrix[cont,], nrow = 8, ncol = 8, byrow = T)
      matrix[i:(i+8-1), j:(j+8-1)] <- block_matrix
      cont <- cont + 1
    }
  }
  return(matrix)
}

Tmatrix <- function(m) {
  t_m <- diag(0, ncol = 64, nrow = 64)
  for (i in 1:m) {
    t_m[i,i] <- 1
  }
  return(t_m)
}

pca <- function(data) {
  lena_block <- as.blockmatrix(data, nrowe = 8, ncole = 8) # Create a block matrix for image data
  x <- blockToObs(lena_block) # Transform a block matrix into a "dataframe" (blocks by row)
  x_cent <- scale(x, center = T, scale = F) # Centering the matrix 
  cov_matrix <- t(x_cent) %*% x_cent # Calculating the Covariance matrix
  
  eigen_pairs <- eigen(cov_matrix) # Calculating eigenvalues and eigenvectors
  eigenvalues <- eigen_pairs$values # Accessing eigenvalues
  eigenvectors <- eigen_pairs$vectors # Accessing eigenvectors
  
  results <- list("x" = x, "eigenvalues" = eigenvalues, "eigenvectors" = eigenvectors)
  return(results)
}

compression <- function(x, eigenvectors, m) {
  y <- x %*% eigenvectors # Creating the new "dataframe" with new p principal components 
  t_m <- Tmatrix(m) # T matrix for define the number of p taking into account
  y_m <- y %*% t_m # Creating the new "dataframe" with new p = dim(t_m) principal components
  
  b <- y_m %*% t(eigenvectors) # Inverse of the transformation
  B <- obsToBlock(b) # The image generating matrix
  return(B) # Returning the image matrix
}

PCA <- pca(lena)