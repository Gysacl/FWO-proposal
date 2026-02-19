library(here)
library(readr)
library(tidyr)
library(sf)
library(tmap)

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

## datasets to shapefiles 
VMMbiotasf <- st_as_sf(VMMbiota, coords = c("Lambert.X", "Lambert.Y"), crs = 3812)

VMMlinksf <- st_as_sf(VMMlink, coords = c("VispuntX","VispuntY"), crs = 31370)

## maps 
tmap_mode("view")+
  tm_shape(VMMbiotasf)+
  tm_dots(fill_alpha = 0.5, fill = "black", size = 0.7)+
  tm_shape(VMMlinksf)+
  tm_dots(fill_alpha = 0.5, fill = "blue", size = 0.7)

