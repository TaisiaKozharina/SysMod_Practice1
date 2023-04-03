test_exp <- function(sample, L){
  set.seed(123)
  control <- rexp(500, rate = L)
  
  p1<-hist(control) 
  p2<-hist(sample)
  plot( p1, col=rgb(0,0,1,1/4), main="Histogram of Control and Custom samples")  # first histogram
  plot( p2, col=rgb(1,0,0,1/4), add=T)  # second
  legend("topright", legend = c("R-generated", "Custom sample"), fill = c(rgb(0,0,1,1/4), rgb(1,0,0,1/4)))
  
  #KS
  ks.test(sample, "pexp", rate = L)
  
  #Chi-square
}

test_norm <- function(sample, m, b){
  set.seed(123)
  control <- rnorm(500, mean=m, sd=b)
  
  p1<-hist(control) 
  p2<-hist(sample)
  plot( p1, col=rgb(0,0,1,1/4), main="Histogram of Control and Custom samples")  # first histogram
  plot( p2, col=rgb(1,0,0,1/4), add=T)  # second
  legend("topright", legend = c("R-generated", "Custom sample"), fill = c(rgb(0,0,1,1/4), rgb(1,0,0,1/4)))
  
  #KS
  ks.test(sample, "pnorm", m, b)
  
  #Chi-square
}

path='C:\\Users\\Kozarina.T\\Desktop\\Docs\\pers\\SysModelling\\CSV\\rand_check.csv'
df <- read.csv(path)
head(df)

test_exp(df$Exp1, 1.5)
test_exp(df$Exp2, 4)
test_norm(df$Norm1, 2, 0.3)
test_norm(df$Norm2, 2.5, 0.5)