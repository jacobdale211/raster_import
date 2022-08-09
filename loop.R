
#import data
input <- read_stars("/Users/jacobdale/raster_import/raw_2008_halpern/population.tif/")
brange <- sf::st_read("/Users/jacobdale/Documents/birds_multistress/Bylot_non_breeding_range.shp")

path <- dir("/Users/jacobdale/raster_import/raw_2008_halpern/", pattern = ".tif", full.names = TRUE)
dat <- lapply(path, read_stars, proxy = TRUE)
#dat <- list()
class(dat)
View(dat)

#create smaller zone
brange_small = brange[1:1,]
st_area(brange_small)

#renormalizing function
quantNorm <- function(x) {
  id <- x != 0
  x <- x / quantile(x[id], probs = .99, na.rm = T)
  x[x > 1] <- 1
  x[x < 0] <- 0
  x
}

#path <- dir("/Users/jacobdale/raster_import/raw_2008_halpern/", pattern = ".tif", full.names = TRUE)
#for (i in 1:length(path)) {
#  dat[[i]] <- read_stars(path[i])
#}


#for loop to loop basic plot
for (i in 1:length(dat)) {
  input <- dat[[i]]
  nm <- names(input)
  
    
  quantNorm <- function(x) {
    id <- x != 0
    x <- x / quantile(x[id], probs = .99, na.rm = T)
    x[x > 1] <- 1
    x[x < 0] <- 0
    x
  }
#log transformation
brange_small <- st_transform(brange_small, crs = st_crs(input))
ext <- st_bbox(brange_small)
c <- st_crop(input, ext)
x=c
x <- st_as_stars(c)
x2 = log(x+1)

x3 <- x2
x3[[1]] <- quantNorm(x3[[1]])
image(x3)

#x2_df = as.data.frame(x2)
#x3_df = as.data.frame(x3)
#View(x2_df)
#View(x3_df)

#summary(x2_df)
#summary(x3_df)
#####
#grid
brange_small_buffer <- st_buffer(brange_small, 10000)
grid <- st_make_grid(brange_small_buffer, n = c(20,20))
uid <- st_intersects(brange_small_buffer, grid) |> unlist() |> sort()
uid
grid <- grid[uid]

#extract
x_raster <- as(x3, "Raster")
exact_extract(x_raster, brange_small_buffer, function(values, coverage_fraction)
  sum(coverage_fraction))
avg <- exact_extract(x_raster, grid, 'mean')
avg

#final plot
grid<- st_sf(grid)
grid$avg = avg

png(file = glue::glue("/Users/jacobdale/raster_import/{nm}.png"))
plot(grid)
dev.off()
}

#cumulative plot (sum)
cropped_raster <- crop(dat[[1]],extent(dat[[3]]))

files = list.files("/Users/jacobdale/raster_import/raw_2008_halpern/",pattern="*.tif$", full.names=TRUE)
birds_2008 <- stack(files)
total <- calc(birds_2008, sum)


cumul_ap <- c(dat[[1]], dat[[2]], along = "z")
View(cumul_ap)

cumul_sum <- st_apply(cumul_ap, c(1,2), sum)
plot(cumul_sum, grid)



#simple for loop
par(mfrow = c(1, 1))
for (i in 1:length(dat)) {
  
  plot_png = plot(dat[[i]]) 
}




#creating cumulative dataframe
avg_ocean_2008 <- avg

full_data_2008 <- cbind(full_data_2008, avg_ocean_2008)

full_data_2008

tot_avg = rowSums(full_data_2008)

#cumulative plot
grid_tot <-st_sf(grid)
grid_tot$tot_avg  = tot_avg
plot(grid_tot)


#left join, dplyr cbind
#rowSums - remove unique ids of cells
#
### for assessing time to complete analyses:
#system.time()
#benchmark
#tictoc
#system.time({
#  whatever code()
#  some more code()
#})


###dir, pattern