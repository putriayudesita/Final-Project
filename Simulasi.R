# Load required libraries
library(readxl)
library(MASS)

# Load Data
df1 <- read_excel("Scaled Phase One.xlsx")
data <- df1[c("SiO2", "Al2O3")]

# Define MEWMV function
mewmv <- function(data, mu = NULL, sigma = NULL, lambda = 0.1, omega = 0.1, L = 2.73) {
  if (is.null(mu)) mu <- colMeans(data)
  if (is.null(sigma)) sigma <- var(data)
  
  data <- as.matrix(data)
  p <- ncol(data)
  nrow <- nrow(data)
  t <- nrow
  I <- diag(t)
  X <- data %*% t(data)
  
  # Membuat matriks M
  elementM <- lambda * (1 - lambda)^(0:(t - 1))
  M <- matrix(0, nrow = t, ncol = t)
  for (i in 1:t) {
    M[i, 1:i] <- rev(elementM[1:i])
  }
  
  # Perhitungan utama
  trV <- expectation <- var <- UCL <- LCL <- numeric(t)
  elementC <- C <- Q <- NULL
  
  for (tt in 1:nrow) {
    Xt <- X[1:tt, 1:tt]
    It <- I[1:tt, 1:tt]
    Mt <- M[1:tt, 1:tt]
    
    # Buat bobot C
    elementC <- numeric(tt)
    for (i in 1:tt) {
      if (i == 1) {
        elementC[i] <- (1 - omega)^(tt - 1)
      } else {
        elementC[i] <- omega * (1 - omega)^(tt - i)
      }
    }
    C <- diag(elementC)
    
    Q <- t(It - Mt) %*% C %*% (It - Mt)
    trV[tt] <- sum(diag(Q %*% Xt))
    expectation[tt] <- p * sum(diag(Q))
    var[tt] <- 2 * p * sum(Q^2)
    UCL[tt] <- expectation[tt] + (L * sqrt(var[tt]))
    LCL[tt] <- expectation[tt] - (L * sqrt(var[tt]))
  }
  
  result <- list(
    "trV" = trV,
    "UCL" = UCL,
    "LCL" = LCL,
    "elemenC" = elementC,
    "omega" = omega,
    "lambda" = lambda,
    "L" = L
  )
  return(result)
}

### Simulasi ARL0 ###
n <- 500
p <- 2
cor <- 0
mu <- rep(0, p)
sigma <- matrix(cor, nrow = p, ncol = p) + diag(1, p)

rl1 <- rl2 <- rl3 <- numeric(0)

for (rep in 1:1000) {
  data <- mvrnorm(n, mu = mu, Sigma = sigma)
  
  mewmv_omg1_L1 <- mewmv(data, lambda = 0.4, omega = 0.4, L = 3.4476)
  mewmv_omg1_L2 <- mewmv(data, lambda = 0.4, omega = 0.4, L = 3.4470)
  mewmv_omg1_L3 <- mewmv(data, lambda = 0.4, omega = 0.4, L = 3.4463)
  
  # Check out-of-control
  for (omg1_L1 in 1:n) {
    if (mewmv_omg1_L1$trV[omg1_L1] <= mewmv_omg1_L1$LCL[omg1_L1] |
        mewmv_omg1_L1$trV[omg1_L1] >= mewmv_omg1_L1$UCL[omg1_L1]) {
      break
    }
  }
  
  for (omg1_L2 in 1:n) {
    if (mewmv_omg1_L2$trV[omg1_L2] <= mewmv_omg1_L2$LCL[omg1_L2] |
        mewmv_omg1_L2$trV[omg1_L2] >= mewmv_omg1_L2$UCL[omg1_L2]) {
      break
    }
  }
  
  for (omg1_L3 in 1:n) {
    if (mewmv_omg1_L3$trV[omg1_L3] <= mewmv_omg1_L3$LCL[omg1_L3] |
        mewmv_omg1_L3$trV[omg1_L3] >= mewmv_omg1_L3$UCL[omg1_L3]) {
      break
    }
  }
  
  rl1 <- c(rl1, omg1_L1)
  rl2 <- c(rl2, omg1_L2)
  rl3 <- c(rl3, omg1_L3)
  
  cat("ARL0 iteration:", rep, "\n")
  cat("omg1L1", "\t", "omg1L2", "\t", "omg1L3", "\n")
  cat(round(mean(rl1), 2), "\t", round(mean(rl2), 2), "\t", round(mean(rl3), 2), "\n\n")
}

