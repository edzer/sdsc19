## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)
library(sf)
library(tidyverse)
nc = read_sf(system.file("gpkg/nc.gpkg", package="sf"))
pts = st_centroid(st_geometry(nc))
xy = st_coordinates(st_centroid(nc$geom))


## ---- results='asis'-----------------------------------------------------
cols = c(3,5,9:14)
knitr::kable(as.data.frame(nc)[1:7,cols])


## ---- results='asis'-----------------------------------------------------
cols = c(3,5,9:10,16:17)
# xy = st_coordinates((nc$geom))
nc$longitude = xy[,1]
nc$latitude = xy[,2]
knitr::kable(as.data.frame(nc)[1:7,cols])


## ---- results='asis'-----------------------------------------------------
cols = c(3,5,9:14)
nc$geometry = format(pts)
cols = c(3,5,9:10,ncol(nc))
knitr::kable(as.data.frame(nc)[1:7,cols])


## ---- results='asis'-----------------------------------------------------
cols = c(3,5,9:14)
nc$geometry = format(nc$geom, width = 50)
cols = c(3,5,9:10,ncol(nc))
knitr::kable(as.data.frame(nc)[1:7,cols])


## ------------------------------------------------------------------------
plot(nc[c("SID74", "SID79")], key.pos = 4)
st_crs(nc)


## ------------------------------------------------------------------------
knitr::include_graphics('xkcd2.png')

