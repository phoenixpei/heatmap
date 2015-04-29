# Uncomment install packages if running first time and need to install them
# install.packages('shiny')
# devtools::install_github("ramnathv/rCharts")

library(shiny)
library(rCharts)
# library(quantmod)

# x<-setwd("C:/Bitnami/wampstack-5.4.37-0/apache2/htdocs/verizon/VCDB")
# shinyAppDir(x)
runApp("VZApp")
