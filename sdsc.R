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


## ----fig.height=4--------------------------------------------------------
plot(nc[c("SID74")], key.pos = 4, axes = TRUE, graticule = TRUE)
knitr::include_graphics('xkcd.png')


## ---- echo=TRUE----------------------------------------------------------
pts = st_centroid(st_geometry(nc))
st_crs(pts)
pts[[1]]
st_transform(pts[1], "+proj=longlat +datum=WGS84")[[1]]


## ----fig.height=3,fig.width=11-------------------------------------------
par(mfrow = c(1, 3))
suppressMessages(f0 <- f <- st_filter(nc, nc[10,], .predicate = st_intersects))
plot(st_geometry(f0), main = "st_intersects")
plot(st_geometry(f0), col = 'green', add = TRUE)
plot(st_geometry(nc[10,]), col = NA, border = 'red', add = TRUE, lwd = 3)
suppressMessages(f <- st_filter(nc, nc[10,], .predicate = st_touches))
plot(st_geometry(f0), main = "st_touches")
plot(st_geometry(f), col = 'green', add = TRUE)
plot(st_geometry(nc[10,]), col = NA, border = 'red', add = TRUE, lwd = 3)
suppressMessages(sel <- lengths(st_relate(nc, nc[10,], pattern = "F***1****")) > 0)
plot(st_geometry(f0), main = "st_relate: touch along line")
plot(st_geometry(nc)[sel], col = 'green', add = TRUE)
plot(st_geometry(nc[10,]), col = NA, border = 'red', add = TRUE, lwd = 3)


## ----fig.height=3--------------------------------------------------------
library(rnaturalearth)
w = ne_countries(returnclass = "sf")
par(mar=c(3.1,3.1,0.1,0.1))
plot(st_geometry(w), add = FALSE, border = 'orange', axes = TRUE, xlim = c(-180,180))
g = st_make_grid() # global 10-degree grid
plot(g, add = TRUE)
plot(g[c(1,36)], col = c('red', 'green'), add = TRUE)

## ----echo=TRUE-----------------------------------------------------------
g[c(1,36)] %>% st_touches()


## ----fig.height=3--------------------------------------------------------
g = st_make_grid()[1:108]
g1 = st_transform(g, 3031)
par(mar=rep(0,4))
plot(g1)
plot(g1[c(1,36)], col = c('red', 'green'), add = TRUE)
plot(st_transform(w[7,1], 3031), add = TRUE, col = NA, border = 'orange')

## ----echo=TRUE-----------------------------------------------------------
g[c(1,36)] %>% st_transform(3031) %>% st_touches()
g[c(1,36)] %>% st_transform(3031) %>% st_set_precision(units::set_units(1, mm)) %>% st_touches()


## ----fig.height=4,fig.width=11-------------------------------------------
par(mfrow = c(1,2))
g = st_make_grid()
plot(g, axes = TRUE, main = 'equirectangular')
plot(g[c(1,36)], col = c('red', 'green'), add = TRUE)
plot(g1, main = 'polar stereographic')
plot(g1[c(1,36)], col = c('red', 'green'), add = TRUE)


## ------------------------------------------------------------------------
g[c(1,36)] %>% st_transform(3031) %>% st_set_precision(units::set_units(1, mm)) %>% lwgeom::st_make_valid() #`[[`(1) #st_is_valid()


## ------------------------------------------------------------------------
g[[1]]


## ----fig.height = 3, fig.width=11----------------------------------------
g0 = g[1]
p1 = g0 %>% st_set_crs(NA) %>% st_segmentize(0.5)
p2 = g0 %>% st_segmentize(units::set_units(10, km))
par(mfrow = c(1, 2))
plot(p2, axes = TRUE, ylim = c(-80.4,-80), border = 'green', main = 'equirectilinear')
plot(p1, add = TRUE, border = 'red')
p2 %>% st_transform(3031) %>% plot(axes = TRUE, border = 'green', ylim = c(-1.13e6,-1.05e6), main = 'polar stereographic')
st_crs(p1) = 4326
p1 %>% st_transform(3031) %>% plot(add = TRUE, border = 'red')

## ---- echo=TRUE----------------------------------------------------------
st_area(p1) %>% units::set_units(km^2) # segmentized along parallel
st_area(p2) %>% units::set_units(km^2) # segmentized along great circle

## ------------------------------------------------------------------------
a1 = st_area(p1) %>% units::set_units(km^2) # segmentized along parallel
a2 = st_area(p2) %>% units::set_units(km^2) # segmentized along great circle
d = (a1/a2) %>% units::set_units('%')
d - units::set_units(100, "%")


## ----fig.width=11,fig.height=3.5-----------------------------------------
par(mfrow=c(1,2))
par(mar = c(0,0,1,0))
plot(st_geometry(w[7,1]), col = NA, border = 'orange', main = "equirectangular", asp = 2)
plot(st_geometry(st_transform(w[7,1], 3031)), col = NA, border = 'orange', main = "polar stereographic")

## ----echo=TRUE-----------------------------------------------------------
w[7,] %>% st_geometry() %>% st_is_valid()
w[7,] %>% st_geometry() %>% st_transform(3031) %>% st_is_valid()


## ----echo=TRUE-----------------------------------------------------------
1/3 == (1 - 2/3)
(x = c(1/3, 1 - 2/3))
print(x, digits = 20)
diff(x)


## ----echo=TRUE-----------------------------------------------------------
.Machine$double.eps
2.2e-16 * units::set_units(110, km) %>% units::set_units(nm)


## ----out.width=600-------------------------------------------------------
knitr::include_graphics('landuse.png')


## ----fig.width=10,fig.height=2.4-----------------------------------------
suppressPackageStartupMessages(library(stars))
system.file("tif/L7_ETMs.tif", package = "stars") %>% read_stars() %>% `[`(,,,1:4) %>% plot()


## ----out.width=1000------------------------------------------------------
knitr::include_graphics('cube1.png')


## ----out.width=1000------------------------------------------------------
knitr::include_graphics('cube2.png')


## ----out.width=800-------------------------------------------------------
knitr::include_graphics('cube3.png')


## ----out.width=800-------------------------------------------------------
knitr::include_graphics('cube4.png')

