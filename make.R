library(devtools)
library(roxygen2)
library(Rcpp)
setwd("~/Projects/")


devtools::document("wiesbaden")
install("wiesbaden")

setwd("~/Working/")