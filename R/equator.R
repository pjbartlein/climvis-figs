library(sf)
library(tidyverse)

library(rgdal)

df <- data.frame(matrix(ncol = 4, nrow = 0))
names(df) <- c("x", "y", "attribute", "id")
head(df)

id = id + 1
x = seq(-180, 180, by=1)
y = rep(0, 361)
df <- rbind(df, cbind(x, y, 1, id))

plot(df$x, df$y)

# convert to sf point and then lines
# pts_sf <- st_sf(df)
pts_sf <- st_as_sf(df, coords = c("x","y"))
st_set_crs(pts_sf, "+proj=longlat +ellps=sphere")

lines_sf <- pts_sf %>% 
  group_by(id) %>%
  summarise(do_union = FALSE) %>%
  st_cast("LINESTRING")
plot(st_geometry(lines_sf), col=1:2)


# output shapefile
outpath <- "/Users/bartlein/Dropbox/WorkCurrent/ERA5/shp_files/"
outname <- "equator"

# write out as shapefiles 
grat_shape_file <- paste(outpath, outname, sep="")
# writeOGR(outshape, grat_shape_file, outname, driver="ESRI Shapefile", overwrite_layer=TRUE)
st_write(lines_sf, dsn = grat_shape_file, driver="ESRI Shapefile", append=FALSE)

# read the file back in to test
test <- readOGR(grat_shape_file)
class(test)
test
plot(test, xlim=c(-180, 180), ylim=c(-90, 90), axes=TRUE)
