library(sp)           # Spatial classes etc.
library(maptools)     # For getting shapefiles into R
library(spatstat)     # For statistical analysis
library(rgdal)        # For map projections
library(rgeos)        # For GIS operations 

fname <- "D:/Data/GIS/GSHHS_shp_2.2.0/GSHHS_shp/l/GSHHS_l_L1"
getinfo.shape(fname) 
mapdata <- readShapeLines(fname, CRS("+proj=longlat"))

xrange <- c(-15,45)
yrange <- c(30,70)
bound <- cbind(xrange,yrange)
boundbox <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(xrange[2],
	seq(xrange[2],xrange[1],length=200),seq(xrange[1],xrange[2],length=200)),
	c(yrange[2],seq(yrange[1],yrange[1],length=200),seq(yrange[2],yrange[2],
	length=200))))),ID="bb")), proj4str=CRS("+proj=longlat")) # works for conical projections
mapdata.clipped <- gIntersection(mapdata, boundbox)

gxrange <- c(-15,45)
gyrange <- c(30,70)
xinterv <- 10
yinterv <- 10
xgrid <- seq(gxrange[1], gxrange[2], xinterv)
ygrid <- seq(gyrange[1], gyrange[2], yinterv)
grid1 <- gridlines(mapdata.clipped, easts=xgrid, norths=ygrid, ndiscr=100)
gridat1 <- gridat(mapdata.clipped, easts=xgrid, norths=ygrid)

windows()
par(mar=c(3,3,3,3)+0.1)
plot(mapdata.clipped, xlim=bound[,1], ylim=bound[,2], xaxs="i", yaxs="i")
plot(grid1, col="gray60", add=T)
text(coordinates(gridat1), labels=parse(text=as.character(gridat1$labels)), 
	pos=gridat1$pos, offset=-2, col="black")
points(locs, pch=20, col="blue")
plot(boundbox, add=T, lwd=2) 

projstr <- "+proj=aea +lon_0=15e +lat_1=30n +lat_2=70n"
locs.proj <- project(locs, proj=projstr)
mapdata.proj <- spTransform(mapdata, CRS(projstr))



