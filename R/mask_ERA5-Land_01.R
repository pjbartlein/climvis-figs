library(raster)
library(rasterVis)
library(ncdf4)
library(sf)
library(rgeos)
library(rgdal)

# land

# land fraction data set
ncpath <- "/Users/bartlein/Dropbox/WorkCurrent/ERA5/data/ERA5-Land/fixed/"
ncfile <- "ERA5-Land_lsm.nc"
nc_fname <- paste(ncpath, ncfile, sep="")

# output shapefile
outpath <- "/Users/bartlein/Dropbox/WorkCurrent/ERA5/shp_files/"
outname <- "ERA5-Land_land"

# read data as raster
frac <- raster(nc_fname, varname="lsm") # note band
extent(frac)
frac <- rotate(frac)
plot(frac)

# print attributes
attributes(frac)

# reset proj4string/CRS
crs(frac) <- "+proj=longlat +ellps=sphere"

# get 0/1 landmask
hist(frac)
mask <- as.matrix(frac)
mask <- ifelse (mask >= 0.1, 1, 0)
hist(mask)
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
land_shape_file <- paste(outpath, outname, sep="")
writeOGR(outshape, land_shape_file, outname, driver="ESRI Shapefile", overwrite_layer=TRUE)

# read the file back in to test
test <- readOGR(land_shape_file)
class(test)
plot(test, xlim=c(-180, 180), ylim=c(-90, 90), axes=TRUE)
plot(frac, add=TRUE)
plot(test, add=TRUE)

