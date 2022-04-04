library(raster)
library(rgdal)
library(sf)
library(ggplot2)

str_name<-'cumulative_impact_2003.tif'
imported_raster = raster(str_name)

imported_raster
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
brange <- sf::st_read("/Users/jacobdale/Downloads/birds_multistress/Bylot_non_breeding_range.shp")
st_geometry_type(brange)
st_bbox(brange)
brange

plot(st_geometry(brange[1:2,]))
