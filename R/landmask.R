library(raster)
library(rasterVis)
library(ncdf4)
library(sf)
library(rgeos)
library(rgdal)

# ice -- other ice at 0 ka

# land/ice fraction data set
ncpath <- "e:/Projects/LIG_CESM2/mask/source/"
ncfile <- "b.e21.B1850.f09_g17.CMIP6-piControl.001.clm2.h0.PCT_LANDUNIT.110001-120012.nc"
nc_fname <- paste(ncpath, ncfile, sep="")

# read data as raster
frac <- raster(nc_fname, varname="PCT_LANDUNIT", level = 4)
extent(frac)
frac <- rotate(frac)
plot(frac)

# print attributes
attributes(frac)

# reset proj4string/CRS
crs(frac) <- "+proj=longlat +ellps=sphere"

# get 0/1 landmask for other ice
otherice <- as.matrix(frac)
otherice <- ifelse (otherice >= 50, 1, 0)

# knock out Antarctica
otherice[161:192, ] <- 0

# knock out Greenland
otherice[193-185, (252-145):(269-145)] <- 0.0
otherice[193-184, (238-145):(273-145)] <- 0.0
otherice[193-183, (235-145):(279-145)] <- 0.0
otherice[193-182, (233-144):(279-145)] <- 0.0
otherice[193-181, (232-144):(276-145)] <- 0.0
otherice[193-180, (232-144):(275-145)] <- 0.0
otherice[193-179, (231-144):(274-145)] <- 0.0
otherice[193-178, (233-144):(274-145)] <- 0.0
otherice[193-177, (233-144):(274-145)] <- 0.0
otherice[193-176, (241-144):(274-145)] <- 0.0
otherice[193-175, (243-144):(274-145)] <- 0.0
otherice[193-174, (244-144):(273-145)] <- 0.0
otherice[193-173, (244-144):(272-145)] <- 0.0
otherice[193-172, (244-144):(272-145)] <- 0.0
otherice[193-171, (245-144):(271-145)] <- 0.0
otherice[193-170, (245-144):(271-145)] <- 0.0
otherice[193-169, (246-144):(269-145)] <- 0.0
otherice[193-168, (246-144):(263-145)] <- 0.0
otherice[193-167, (246-144):(262-145)] <- 0.0
otherice[193-166, (246-144):(260-145)] <- 0.0
otherice[193-165, (247-144):(257-145)] <- 0.0
otherice[193-164, (248-144):(256-145)] <- 0.0
otherice[193-163, (248-144):(256-145)] <- 0.0
otherice[193-162, (249-144):(255-145)] <- 0.0
otherice[193-161, (250-144):(255-145)] <- 0.0
otherice[193-160, (253-144):(254-145)] <- 0.0

# convert to raster
otherice <- raster(otherice)
extent(otherice) <- extent(frac)
plot(otherice)

# ice -- Greenland ice at 126 ka, 125ka, etc.

experiment <- "119.0ka"

# land/ice fraction data set
ncpath <- "e:/Projects/LIG_CESM2/mask/PCT_LANDUNIT/"
ncfile <- paste("PCT_LANDUNIT_albcorrect_", experiment, ".nc", sep="")
nc_fname <- paste(ncpath, ncfile, sep="")

# output shapefile
outpath <- "e:/Projects/LIG_CESM2/mask/CESM2-CISM2_icemasks/"
outname <- paste("CESM2-CISM2_GL_ice_", experiment, "_albcorrect", sep="")
GL_ice_shape_file <- paste(outpath, outname, sep="")

# read data as raster
frac <- raster(nc_fname, varname="PCT_LANDUNIT", band = 4)
extent(frac)

mask <- as.matrix(frac)
frac <- raster(mask)
extent(frac) <- land_extent
crs(frac) <- "+proj=longlat +ellps=sphere"
frac
plot(frac)

# rotate
frac <- rotate(frac)
plot(frac)

# print attributes
attributes(frac)

# get 0/1 icemak
mask <- as.matrix(frac)
mask <- ifelse (mask >= 50.0, 1, 0)

# knock out Antarctica
mask[161:192, ] <- 0

# convert to raster
mask <- raster(mask)
extent(mask) <- extent(frac)
plot(mask)

# subtract other ice at 0 ka
mask <- mask - otherice
mask[161:192, ] <- NA
plot(mask)

# raster to polygons, dissolve to simple polygons
pline <- rasterToPolygons(mask, fun=function(x) {x == 1}, dissolve = TRUE)
class(pline)
plot(pline)
pline <- as(pline, 'SpatialLinesDataFrame')
class(pline)

# plot both
plot(mask)
plot(pline, add = TRUE, bor="blue", lwd=2)

# attributes of lines
attributes(pline)

# write out as shapefiles 
outshape <- pline
writeOGR(outshape, GL_ice_shape_file, outname, driver="ESRI Shapefile", overwrite_layer=TRUE)

# read the file back in to test
test <- readOGR(GL_ice_shape_file)
plot(test, xlim=c(-180, 180), ylim=c(-90, 90), axes=TRUE)
plot(frac, add=TRUE)
plot(test, add=TRUE)


