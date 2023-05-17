library(tidyr)
library(here)
library(dplyr)

#test data
#load in data, skip 2 rows (y label, title)
SST <- read_csv("data-eiwg/SST.csv", skip = 2)

SST_long <- gather(SST, region, degC, 2:10, factor_key=TRUE)
SST_format <- SST_long %>% mutate(title = "SST")
colnames(SST_format) <- c('y','region','x','title')
head(SST_format)

#test batch
#take a swing at loop

eiwg_files <- list.files(here::here("data-eiwg"))
for(i in eiwg_files) {
  name <- gsub(".csv","",i)
  assign(name,
  read.csv(here("data-eiwg",i), skip = 2))
}
#this^ works but you lose units

indicator_names <- gsub(".csv","",eiwg_files)
dfs <- Filter(function(x) is(x, "data.frame"), mget(ls()))
res<- lapply(dfs, function(w) {gather(w, region, unit, 2:ncol(w), factor_key=TRUE)})
indicators <- mapply(cbind, res, "title"=indicator_names, SIMPLIFY=F)

#produces list of indicator dfs in same format as dummy data
