library(sf)
library(tidyverse)

library(rgdal)

df <- data.frame(matrix(ncol = 4, nrow = 0))
names(df) <- c("x", "y", "attribute", "id")
head(df)

id = 0
for (lat in seq(-60, 60, by = 30)) {
  id = id + 1
  x = seq(-180, 180, by=1)
  y = rep(lat, 361)
  df <- rbind(df, cbind(x, y, 1, id))
}
plot(df$x, df$y)

for (lon in seq(-150, -30, by = 30)) {
  id = id + 1
  y = seq(-60, 60, by=1)
  x = rep(lon, 121)
  df <- rbind(df, cbind(x, y, 1, id))
}
plot(df$x, df$y)

for (lon in seq(30, 150, by = 30)) {
  id = id + 1
  y = seq(-60, 60, by=1)
  x = rep(lon, 121)
  df <- rbind(df, cbind(x, y, 1, id))
}
plot(df$x, df$y)

for (lon in seq(-180, 0, by = 180)) {
  id = id + 1
  y = seq(-90, 90, by=1)
  x = rep(lon, 181)
  df <- rbind(df, cbind(x, y, 1, id))
}
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
outname <- "grat30_nopole"

# write out as shapefiles 
grat_shape_file <- paste(outpath, outname, sep="")
# writeOGR(outshape, grat_shape_file, outname, driver="ESRI Shapefile", overwrite_layer=TRUE)
st_write(lines_sf, dsn = grat_shape_file, driver="ESRI Shapefile", append=FALSE)

# read the file back in to test
test <- readOGR(grat_shape_file)
class(test)
test
plot(test, xlim=c(-180, 180), ylim=c(-90, 90), axes=TRUE)
