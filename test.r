test_exp <- function(sample, L){
  set.seed(123)
  control <- rexp(500, rate = L)
  p1<-hist(control, breaks=15) 
  p2<-hist(sample)
  plot( p1, col=rgb(0,0,1,1/4), main="Histogram of Control and Custom samples")  # first histogram
  plot( p2, col=rgb(1,0,0,1/4), add=T)  # second
  legend("topright", legend = c("R-generated", "Custom sample"), fill = c(rgb(0,0,1,1/4), rgb(1,0,0,1/4)))
  
  
  empirical_lambda <- 1/mean(sample)
  print(empirical_lambda)
  
  print(mean(sample))
  print(mean(control))
  
  #KS
  ks <- ks.test(sample, "pexp", rate = L)
  print(ks)
  
  #Chi-square for homogenity
  chi <- chisq.test(sample,control)
  print(chi)
}

test_norm <- function(sample, m, b){
  set.seed(123)
  control <- rnorm(500, mean=m, sd=b)
  
  p1<-hist(control, breaks=15) 
  p2<-hist(sample)
  plot( p1, col=rgb(0,0,1,1/4), main="Histogram of Control and Custom samples")  # first histogram
  plot( p2, col=rgb(1,0,0,1/4), add=T)  # second
  legend("topright", legend = c("R-generated", "Custom sample"), fill = c(rgb(0,0,1,1/4), rgb(1,0,0,1/4)))
  
  empirical_mean <- mean(sample)
  print(empirical_mean)
  
  empirical_sd <- sd(sample)
  print(empirical_sd)
  
  #KS
  ks <- ks.test(sample, "pnorm", mean=m, sd=b)
  print(ks)
  
  #Chi-square
  chi <- chisq.test(sample,control)
  print(chi)
}

path='C:\\Users\\...\\SysMod_Practice1\\CSV\\rand_check.csv'
df <- read.csv(path)
head(df)


test_exp(df$Exp1, 1.5)
test_exp(df$Exp2, 4)
test_norm(df$Norm1, 2, 0.3)
test_norm(df$Norm2, 2.5, 0.5)


#For MoE statistics
stats <- c(2525, 2468, 2535, 2548, 2562, 2478, 2563, 2408, 2649, 2554)

mean(stats)
median(stats)
sd(stats)
t.test(stats)$conf.int

#For Statistical testing / comparison of models
q1 <- c(2541, 2623, 2538, 2622, 2542, 2652, 2500, 2554, 2415, 2507)
q2 <- c(2447, 2461, 2467, 2377, 2517, 2343, 2500, 2416, 2511, 2469)
q3 <- c(2525, 2468, 2535, 2548, 2562, 2478, 2563, 2408, 2649, 2554)

t.test(q1, q2, var.equal = TRUE)

wilcox.test(q1, q2)




