## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(sf)
library(tidyverse)
nc = read_sf(system.file("gpkg/nc.gpkg", package="sf"))


## ---- results='asis'-----------------------------------------------------
cols = c(3,5,9:14)
knitr::kable(as.data.frame(nc)[1:7,cols])


## ------------------------------------------------------------------------
# knitr::kable(as.data.frame(nc)[1:7,cols])
nc[1:7,cols]

