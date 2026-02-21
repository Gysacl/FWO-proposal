library(here)
library(readr)
library(tidyr)
library(sf)
library(tmap)
library(leaflet)
library(dplyr)

## import datasets 
VMMbiota = read.csv(here("Analyseresultaten biota_2014_2024.csv"), sep = ";")
  VMMbiota <- na.omit(VMMbiota)
  VMMbiota$Lambert.X = as.numeric(VMMbiota$Lambert.X)
  VMMbiota$Lambert.Y = as.numeric(VMMbiota$Lambert.Y)
VMMlink <- read.table("fc_VIS_link_obs.csv", header = FALSE, sep = " ", stringsAsFactors = FALSE, fill = TRUE, skip = 1)
  VMMlink$Geometrie <- paste0(VMMlink$V7,VMMlink$V8)
  VMMlink$V7 <- NULL
  VMMlink$V8 <- NULL
  VMMlink <- VMMlink[ , -1]
  colnames(VMMlink) <- c("VispuntWID", "WaarnemingWID", "Datum", "VispuntX", "VispuntY", "geometry")
VMMlink <- VMMlink[ , -2]
VMMlink <- VMMlink[ , -2]
VMMlink <- unique( VMMlink )

  
shape <- read_sf(here("world-administrative-boundaries.shp"))
Belgium <- shape %>% filter(ISO_3_terri == "BEL")
shape2 <- read_sf(here("georef-belgium-region-millesime.shp"))
Vlaanderen <- shape2[ 1, ]

## datasets to shapefiles 
VMMbiotasf <- st_as_sf(VMMbiota, coords = c("Lambert.X", "Lambert.Y"), crs = 3812)

VMMlinksf <- st_as_sf(VMMlink, coords = c("VispuntX","VispuntY"), crs = 31370)



##  maps tmap 
# complete overview 
tmap_mode("plot")+
  tm_shape(Vlaanderen)+
  tm_lines(lwd = 5)+
  tm_shape(VMMlinksf)+
  tm_dots(fill_alpha = 0.8, fill = "red", size = 1)+
  tm_shape(VMMbiotasf)+
  tm_dots(fill_alpha = 0.8, fill = "blue", size = 0.7)


# biota 
tmap_mode("plot")+
  tm_shape(Vlaanderen)+
  tm_lines(lwd = 5)+
  tm_shape(VMMbiotasf)+
  tm_dots(fill_alpha = 1, fill = "#009E73", size = 0.7)

# VMM(fysico-chemie)  +  VIS --> al gekoppeld! 
tmap_mode("plot")+
  tm_shape(Vlaanderen)+
  tm_lines(lwd = 5)+
  tm_shape(VMMlinksf)+
  tm_dots(fill_alpha = 1, fill = "#CC79A7", size = 0.7)

# VMM(fysico-chemie)  +  VIS --> al gekoppeld! 
tmap_mode("view")+
  tm_shape(Vlaanderen)+
  tm_lines(lwd = 5)+
  tm_shape(VMMlinksf)+
  tm_dots(fill_alpha = 0.2, fill = "red", size = 1)+
  tm_shape(VMMbiotasf)+
  tm_dots(fill_alpha = 0.8, fill = "blue", size = 0.7)+
  tm_shape(join)+
  tm_dots(fill_alpha = 0.8, fill = "yellow", size = 0.7)

# testje overlappende punten --> fysico-chemi + biota! 
VMMbiotasf <- st_transform(VMMbiotasf, st_crs(VMMlinksf))
join <- st_join(
  VMMlinksf,
  VMMbiotasf,
  join = st_is_within_distance,
  dist = 100)
join <- na.omit(join)
