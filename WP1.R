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
  
shape <- read_sf(here("world-administrative-boundaries.shp"))
Belgium <- shape %>% filter(ISO_3_terri == "BEL")

## datasets to shapefiles 
VMMbiotasf <- st_as_sf(VMMbiota, coords = c("Lambert.X", "Lambert.Y"), crs = 3812)

VMMlinksf <- st_as_sf(VMMlink, coords = c("VispuntX","VispuntY"), crs = 31370)



##  maps tmap 
# complete overview 
tmap_mode("view")+
  tm_shape(Belgium)+
  tm_lines(lwd = 5)+
  tm_shape(VMMlinksf)+
  tm_dots(fill_alpha = 0.5, fill = "red", size = 0.7)+
  tm_shape(VMMbiotasf)+
  tm_dots(fill_alpha = 0.8, fill = "blue", size = 0.7)


# biota 
tmap_mode("plot")+
  tm_shape(Belgium)+
  tm_lines(lwd = 5)+
  tm_shape(VMMbiotasf)+
  tm_dots(fill_alpha = 0.5, fill = "blue", size = 0.7)

# VMM(fysico-chemie)  +  VIS --> al gekoppeld! 
tmap_mode("plot")+
  tm_shape(Belgium)+
  tm_lines(lwd = 5)+
  tm_shape(VMMlinksf)+
  tm_dots(fill_alpha = 0.5, fill = "red", size = 0.7)

