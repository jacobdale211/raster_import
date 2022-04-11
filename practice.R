if (!file.exists('data')) dir.create('data')

id <- "f612e2b4-5c67-46dc-9a84-1154c649ab4e"
govcan_dl_resources(id, path = 'data/dat.csv')

dat <- read.csv(path = "data/dat.csv", exdir = 'data')

