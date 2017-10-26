library(sp)
library(rgdal)
library(raster)
library(plyr)
library(rgeos)
library(leaflet)
library(rmapshaper)
library(htmlwidgets)

setwd(mydir)
Postcodes <- readOGR("Areas.shp")
Postcodes_Loc <- readOGR("Districts.shp")

LabelPC <- sprintf(
  "<strong>%s</strong>", Postcodes$name
) %>% lapply(htmltools::HTML)

LabelFoc <- sprintf(
  "<strong>%s</strong>", Postcodes_Loc$name
) %>% lapply(htmltools::HTML)




PC_Leaflet <- leaflet(Postcodes) %>% addTiles() %>%
  fitBounds(-8.65,48.89,1.76,60.86) %>% 
  addPolygons(stroke = TRUE,
              popup = ~name) 


PC_Leaflet_ed <- leaflet(Postcodes) %>% addTiles() %>%
  fitBounds(-8.65,48.89,1.76,60.86) %>%
  addPolygons(stroke = TRUE,color = "black", weight = 3, smoothFactor = 0.5,
              popup = ~name,
              fillColor = "transparent",
              highlightOptions = highlightOptions(color = "red", weight = 2,
                                                  bringToFront = TRUE)) 
              

PC_Leaflet_ed_layers <- leaflet() %>% addTiles(group = "OSM (default)") %>%
  fitBounds(-8.65,48.89,1.76,60.86) %>%
  addPolygons(data = Postcodes,stroke = TRUE,color = "black", weight = 3, smoothFactor = 0.5,
              label = ~name,
              fillColor = "transparent",
              highlightOptions = highlightOptions(color = "blue", weight = 2,
                                                  bringToFront = TRUE), group = "Areas") %>%
  addPolygons(data = Postcodes_Loc,stroke = TRUE,color = "red", weight = 1, smoothFactor = 0.5,
              label = ~name,
              fillColor = "transparent",
              highlightOptions = highlightOptions(color = "green", weight = 2,
                                                  bringToFront = TRUE), group = "Districts") %>%

addLayersControl(
  baseGroups = c("OSM (default)"),
  overlayGroups = c("Areas", "Sectors"),
  options = layersControlOptions(collapsed = FALSE)) 

saveWidget(PC_Leaflet_ed,file = "UK_Postcodes.html")

PC_Leaflet <- leaflet() %>% addTiles(group = "OSM (default)") %>%
  fitBounds(-8.65,48.89,1.76,60.86) %>%
  addPolygons(data = Postcodes,stroke = TRUE,color = "black", weight = 3, smoothFactor = 0.5,
              label = ~name,
              fillColor = "transparent",
              highlightOptions = highlightOptions(color = "blue", weight = 2,
                                                  bringToFront = TRUE), group = "Areas") 

saveWidget(PC_Leaflet,file = "UK_Postcodes_Simp.html")
