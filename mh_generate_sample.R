## This is the distribution we need to sample from. 
##  0.3*f(mu1, sigma1^2) + 0.7f(mu2, sigma2^2)
##  f is density for the normal distribution
##  This needs to be evaluated at either the proposed position of the chain
##  or the current position of the chain

#  Bimodal normal 
mixed.normal <- function(phi) {
  mu1 <- 0.5  # Setting the mean and variance. 
  mu2 <- 4
  sigma1 <- 1
  sigma2 <- .5
  y <- .3*(exp(-(phi - mu1)^2/(2 * sigma1^2))/(sigma1 * sqrt(2*pi))) + 
    .7*(exp(-(phi - mu2)^2/(2 * sigma2^2))/(sigma2 * sqrt(2*pi)))
  y
}


#### This needs to be set - sample size
ndraws <- 50000

#  Write a closure function for different tuning parameters. 
tuning_x <- function(tuning) {
  function(ndraws) {  
    # Data frame with the attempts 
    attempt.df <- data.frame(draws=NA, attempts=NA, acceptance=NA,
                             dist.draw=NA, dist.attempt=NA, tuning=NA)
    draw <- 10 # initial starting value. 
    mixed.normal.draw <- mixed.normal(draw)
    for (i in 1:ndraws) {
      # Adds epsilon and then tries to move there. 
      attempt <- draw + rnorm(1, 0, tuning)
      # pdf of target distribution
      mixed.normal.attempt <- mixed.normal(attempt)
      # acceptance probability versus uniform random draw
      accept <- rbinom(1, 1, min(1, mixed.normal.attempt/mixed.normal.draw))
      if (accept) {
        draw <- attempt
        mixed.normal.draw <- mixed.normal.attempt
      }
      attempt.df[i,] <- c(draw, attempt, accept, mixed.normal.draw, 
                          mixed.normal.attempt, tuning)
    }
  return(attempt.df)  
  }
}

tuning.5 <- tuning_x(0.5)
tuning_3 <- tuning_x(3)
tuning_10 <- tuning_x(10)

list.sample <- list()

set.seed(140)   # for reproducibility.

# Generate sampled values
list.sample[[1]] <- tuning.5(51000)
list.sample[[2]] <- tuning_3(51000)
list.sample[[3]] <- tuning_10(51000)


# save these to .rds for shiny to use. 
saveRDS(list.sample, file="metropolis-hastings/list_sample.rds")
