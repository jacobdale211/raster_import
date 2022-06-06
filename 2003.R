library(raster)
library(rgdal)
library(sf)
library(ggplot2)

str_name<-'inorganic.tif'
imported_raster = raster(str_name)

imported_raster
summary(imported_raster)
#class      : RasterLayer 
#dimensions : 19305, 38610, 745366050  (nrow, ncol, ncell)
#resolution : 934.4789, 934.4789  (x, y)
#extent     : -18040095, 18040134, -9020047, 9020067  (xmin, xmax, ymin, ymax)
#crs        : +proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs 
#source     : cumulative_impact_2003.tif 
#names      : cumulative_impact_2003 
#values     : 0, 11.72294  (min, max)

#pseudocode
#import birdlife data
#import direct human impact from halpern

library(sf)
brange <- sf::st_read("/Users/jacobdale/Documents/birds_multistress/Bylot_non_breeding_range.shp")
st_geometry_type(brange)
st_bbox(brange)
brange

plot(st_geometry(brange[1:2,]))


#####
#intersect 
library(stars)
inorganic <- read_stars("/Users/jacobdale/raster_import/inorganic.tif/")


str(brange)
class(brange)
class(inorganic)

brange_small = brange[1:1,]
plot(brange_small)
st_area(brange_small)
#breakdown areas of range into grid (later on)

brange_small <- st_transform(brange_small, crs = st_crs(inorganic))

ext <- st_bbox(brange_small)
inorganic_c <- st_crop(inorganic, ext)
x=inorganic_c
class(x)
x <- st_as_stars(inorganic_c)
class(x)
x2 = log(x+1)
image(x)
image(x2)

plot(st_geometry(brange_small), add = TRUE)

#class(inorganic_c)
#st_intersects(brange_small, x)

pol <- st_as_sf(x, as_points = FALSE, merge = TRUE)
int <- st_intersects(pol, brange_small)

#st_buffer() - overlap btwn stopover and marine driver data to incorporate data that is not terrestrial

grid <- st_make_grid(brange_small)
plot(grid)
plot(st_geometry(brange_small), add = TRUE)
uid <- st_intersects(brange_small, grid) |> unlist() |> sort()
uid
grid <- grid[uid]

#####
#buffer
st_boundary(brange_small)
plot(brange_small)

#just trying to see how st_buffer works
plot(st_buffer(brange_small, dist = 1, joinStyle="ROUND"), reset = FALSE, main = "joinStyle: ROUND")

brange_small_buffer <- st_buffer(brange_small, 10000)
plot(brange_small_buffer)

#####
#extract
x_raster <- as(x, "Raster")
exact_extract(x_raster, brange_small_buffer, function(values, coverage_fraction)
  sum(coverage_fraction))
#1447527
avg <- exact_extract(x_raster, grid, 'mean')
#0.07897207
avg


grid <- st_sf(grid)
grid$avg = avg
plot(grid)





#DECEMBER 1 ARTICNET CONFERENCE IN TORONTO
#QUEBEC OCEAN CONFERENCE - SOMETIME IN NOVEMBER








