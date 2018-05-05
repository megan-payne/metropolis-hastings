# Metropolis Hastings, An Example and Shiny Application

This is the implementation of the Metropolis Hastings algorithm, a Markov Chain Monte Carlo (MCMC) process to sample from a probability distribution when direct sampling is difficult. Direct sampling can often be an intractable problem, which is when an MCMC technique might be used instead. 

The basic concept of the Metropolis Hastings algorithm is as follows. 

Begin at a starting point. The location of this point does not matter because it will quickly change. Add a randomly generated small number to this point and attempt to move there. 


## The Shiny App 

Shiny is a great visualization tool that is quick to build to show the end result of data analysis, or in this case data simulation. [Try it out!](https://meganp.shinyapps.io/shiny/ "Metropolis Hastings at Shinyapps")  

The following bimodal normal density was used for this example. 

$$\frac{0.3}{\sqrt{(2*\pi*1^2)}}*\exp^{\frac{-(\phi - 0.5)^2}{(2 * 1^2)}} + 
    \frac{0.7}{\sqrt{(2*\pi*0.5^2)}}*\exp^{\frac{-(\phi - 4)^2}{(2 * 0.5^2)}}$$

The parameters that can be changed are the tuning parameter, the burn, and the sample size. The tuning parameter is the size of the step used to traverse the space. Too big of a tuning parameter and the steps are too big, making convergence to the desired density function either difficult or unlikely to happen. On the other hand, if the tuning parameter is too small and the steps aren't large enough, the algorithm can get stuck and not traverse the entire space. Since the algorithm should converge to the desired density, regardless of the starting point, a burn is often used. That is, the beginning of the chain is discarded to allow for a bad choice in starting point. The sample size is simply the number of datapoints in the simulated dataset. 

![A screenshot of the Shiny application written to provide an example of the Metropolis Hastings example.](shiny.jpg "Screenshots of the Shiny app")








###  A bit more detail 

Once the sampling distribution is decided, the tuning parameters are set. In this example, I used several different tuning parameters, 0.5, 3, 10. What these represent is the step size of the attempted draw. The move is a randomly generated number using the normal distribution with mean 0 and standard deviation equal to the tuning parameter. The larger the standard deviation, the more likely it is that this step size is larger.  

```R
#  How the tuning parameter is used.
attempt <- current.location + rnorm(1, 0, tuning)
```
The burn in is done in the plotting of the sampled values. The first n values are thrown away, depending on the desired size of the burn in. 

Lastly, the number of draws needs to be chosen. I chose 50,000 as the maximum number of datapoints to be displayed but my simulation code generates 51,000 datapoints to pad the data set for the user-defined burn in. 


## How the algorithm works 

1. Start with an initial position for the chain. This value doesn't matter so much. 
2. Add a random number to the initial position and attempt to move there. 
3. Decide whether or not to accept the change in position with probability p, which is itself a function of the proposed move versus accepted move. 
4. If the change in position is accepted, move, otherwise remain in the current position. 
5. Go back to step 2, using the current position. Repeat this until converegence to the desired density function and the desired sample size is reached. 


# Acceptance criterion

Once a move in location is proposed, the change in position is completed based on an accept-reject criteria. The basic method is to accept the proposed change if it occurs with high enough probability. In this example, both the current position and the proposed position are evaluated using the desired density function. The ratio of the two is taken and used as the acceptance probability. 

```R
      # acceptance probability versus uniform random draw
      accept <- rbinom(1, 1, min(1, mixed.normal.attempt/mixed.normal.draw))
```

# Plotting the results 

## Histogram of the sampled values

The main result of the Shiny application is to demonstrate how the sampled values are changed by the change in tuning parameter, burn-in, and sample size. 

## Trace plots

The code for the trace plot needs to be added. This is the plot of the accepted chain positions through time. This gives a visual idea of the acceptance/rejection rates because flatness in the plot indicates that the change in position was rejected. 





