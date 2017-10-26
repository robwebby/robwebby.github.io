library(sp)
library(rgdal)
library(raster)
library(plyr)
library(rgeos)
library(leaflet)
library(rmapshaper)
library(htmlwidgets)




Postcodes <- readOGR("Areas.shp")
Postcodes_Loc <- readOGR("Districts.shp")

LabelPC <- sprintf(
  "<strong>%s</strong>", Postcodes$name
) %>% lapply(htmltools::HTML)

LabelFoc <- sprintf(
  "<strong>%s</strong>", Postcodes_Loc$name
) %>% lapply(htmltools::HTML)







PC_Leaflet <- leaflet() %>% addTiles(group = "OSM (default)") %>%
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
    baseGroups = c("Areas", "Districts"),
    options = layersControlOptions(collapsed = FALSE)) 

saveWidget(PC_Leaflet,file = "UK_Postcodes.html")

PC_Leaflet_Areas <- leaflet() %>% addTiles(group = "OSM (default)") %>%
  fitBounds(-8.65,48.89,1.76,60.86) %>%
  addPolygons(data = Postcodes,stroke = TRUE,color = "blue", weight = 1, smoothFactor = 0.5,
              label = ~name,
              fillColor = "transparent",
              highlightOptions = highlightOptions(color = "blue", weight = 2,
                                                  bringToFront = TRUE), group = "Areas") 

PC_Leaflet_Dis <- leaflet() %>% addTiles(group = "OSM (default)") %>%
  fitBounds(-8.65,48.89,1.76,60.86) %>%
  addPolygons(data = Postcodes_Loc,stroke = TRUE,color = "black", weight = 1, smoothFactor = 0.5,
              label = ~name,
              fillColor = "transparent",
              highlightOptions = highlightOptions(color = "blue", weight = 2,
                                                  bringToFront = TRUE), group = "Districts") 

saveWidget(PC_Leaflet,file = "UK_Postcodes_Simp.html")
saveWidget(PC_Leaflet_Dis,file = "UK_Postcodes_Dis.html")
saveWidget(PC_Leaflet_Areas,file = "UK_Postcodes_Area.html")

