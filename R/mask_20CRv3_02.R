library(raster)
library(rasterVis)
library(ncdf4)
library(sf)
library(rgeos)
library(rgdal)

# land

# land fraction data set
ncpath <- "/Users/bartlein/Dropbox/WorkCurrent/20CRv3/shp_files/"
ncfile <- "land.nc"
nc_fname <- paste(ncpath, ncfile, sep="")

# output shapefile
outpath <- "/Users/bartlein/Dropbox/WorkCurrent/20CRv3/shp_files/"
outname <- "20CRv3_land"

# read data as raster
# frac <- raster(nc_fname, varname="mask")
frac <- raster(nc_fname, varname="land") # note band
extent(frac)
frac <- rotate(frac)
plot(frac)

# print attributes
attributes(frac)

# reset proj4string/CRS
crs(frac) <- "+proj=longlat +ellps=sphere"

# get 0/1 landmask
mask <- as.matrix(frac)
mask <- ifelse (mask >= 1, 1, 0)
mask <- raster(mask)
extent(mask) <- extent(frac)

# raster to polygons, dissolve to simple polygons
pline <- rasterToPolygons(mask, fun=function(x) {x == 1}, dissolve = TRUE)
class(pline)
plot(pline)
pline <- as(pline, 'SpatialPolygonsDataFrame')
class(pline)

# plot both
plot(mask)
plot(pline, add = TRUE, bor="blue", lwd=2)

# attributes of lines
attributes(pline)

# write out as shapefiles 
outshape <- pline
land_shape_file <- paste(outpath, outname, sep="")
writeOGR(outshape, land_shape_file, outname, driver="ESRI Shapefile", overwrite_layer=TRUE)

# read the file back in to test
test <- readOGR(land_shape_file)
class(test)
plot(test, xlim=c(-180, 180), ylim=c(-90, 90), axes=TRUE)
plot(frac, add=TRUE)
plot(test, add=TRUE)

# ice
# ice fraction data set
ncpath <- "/Users/bartlein/Dropbox/WorkCurrent/20CRv3/shp_files/"
ncfile <- "vegtype.nc"
nc_fname <- paste(ncpath, ncfile, sep="")

# output shapefile
outpath <- "/Users/bartlein/Dropbox/WorkCurrent/20CRv3/shp_files/"
outname <- "20CRv3_ice"

# read data as raster
veg <- raster(nc_fname)
extent(veg)
veg <- rotate(veg)
plot(veg)

# print attributes
attributes(veg)

# reset proj4string/CRS
crs(frac) <- "+proj=longlat +ellps=sphere"

# get 0/1 landmask
mask <- as.matrix(veg)
mask <- ifelse (mask >= 13, 1, 0)
mask <- raster(mask)
extent(mask) <- extent(frac)
plot(mask)

# raster to polygons, dissolve to simple polygons
pline <- rasterToPolygons(mask, fun=function(x) {x == 1}, dissolve = TRUE)
class(pline)
plot(pline)
pline <- as(pline, 'SpatialPolygonsDataFrame')
class(pline)

# plot both
plot(mask)
plot(pline, add = TRUE, bor="blue", lwd=2)

# attributes of lines
attributes(pline)

# write out as shapefiles 
outshape <- pline
ice_shape_file <- paste(outpath, outname, sep="")
writeOGR(outshape, ice_shape_file, outname, driver="ESRI Shapefile", overwrite_layer=TRUE)

# read the file back in to test
test <- readOGR(ice_shape_file)
plot(test, xlim=c(-180, 180), ylim=c(-90, 90), axes=TRUE)
plot(frac, add=TRUE)
plot(test, add=TRUE)

# plot both
land_test <- readOGR(land_shape_file)
ice_test <- readOGR(ice_shape_file)
plot(land_test, col="blue")
plot(ice_test, col="magenta", add=TRUE)

