library(sp)
library(rgdal)
library(raster)
library(plyr)
library(rgeos)
library(leaflet)
library(rmapshaper)
library(htmlwidgets)

setwd(mydir)
Constituencies <- readOGR("westminster_const.shp")
Ref_Votes <- read.csv("Estimates_Leave_Vote.csv")
GE_2015 <- read.csv("GE2015_Results.csv")
GE_2010 <- read.csv("GE2010_Results.csv")

latlong = "+init=epsg:4326"

Constituencies_WGS <- spTransform(Constituencies,latlong)

Constituencies_WGS <- ms_simplify(Constituencies_WGS,keep = 0.001,keep_shapes = TRUE)

Referendum_WGS <- merge(Constituencies_WGS,Ref_Votes, by = "CODE")
GE2015_WGS <- merge(Constituencies,GE_2015, by = "CODE")
GE2010_WGS <- merge(Constituencies_WGS,GE_2010, by = "CODE")
Combo_WGS <- merge(GE2015_WGS,Referendum_WGS, by = "CODE")
Combo_WGS <- merge(Combo_WGS,GE_2010, by = "CODE")

altbin <- c(0,10,20,30,40,50,60,70,80,90,100)

altpal <- colorBin(c('#08519c','#3182bd','#6baed6','#9ecae1','#c6dbef','#fdd0a2', '#fdae6b','#fd8d3c','#e6550d','#a63603'), domain = Combo_WGS$Estimated.Leave.vote, bins = altbin)

Elec15pal <- colorFactor(c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold","darkorchid1"), GE2015_WGS$Winner.15)

Elec10pal <- colorFactor(palette =  c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold"), domain =  Combo_WGS$Winner.10)

labelleave <- sprintf(
  "<strong>%s</strong><br/> <strong> %g </strong> percentage votes for Leave  <br /> <strong> %g </strong> percentage votes for Remain", Combo_WGS$NAME,Combo_WGS$Estimated.Leave.vote,Combo_WGS$Estimated.Remain
) %>% lapply(htmltools::HTML)

labelelec2015 <- sprintf(
  "<strong>%s 2015 </strong><br/> Lab Vote Share <strong> %g  (%g) </strong> <br /> Con Vote Share <strong> %g (%g) </strong> <br />Lib Dem Vote Share <strong> %g  (%g)</strong> <br />UKIP Vote Share <strong> %g (%g) </strong> <br />SNP Vote Share <strong> %g (%g) </strong> <br />Green Vote Share <strong> %g (%g) </strong> <br />Other Vote Share <strong> %g (%g) </strong> <br />", GE2015_WGS$NAME,GE2015_WGS$Labour.Vote.Share.15,GE2015_WGS$Labour.Vote.Share.Change.15,GE2015_WGS$Conservative.Vote.Share.15,GE2015_WGS$Conservative.Vote.Share.Change.15,GE2015_WGS$Lib.Dems.Vote.Share.15,GE2015_WGS$Lib.Dems.Vote.Share.Change.15,GE2015_WGS$UKIP.Vote.Share.15,GE2015_WGS$UKIP.Vote.Share.Change.15,GE2015_WGS$SNP.Vote.Share.15,GE2015_WGS$SNP.Vote.Share.Change.15,GE2015_WGS$Green.Vote.Share.15,GE2015_WGS$Green.Vote.Share.Change.15,GE2015_WGS$Other.Vote.Share.15,GE2015_WGS$Other.Vote.Share.Change.15
) %>% lapply(htmltools::HTML)

labelelec2010 <- sprintf(
  "<strong>%s</strong><br/> Lab Vote Share <strong> %g </strong> <br /> Con Vote Share <strong> %g </strong> <br />Lib Dem Vote Share <strong> %g </strong> <br />UKIP Vote Share <strong> %g </strong> <br />SNP Vote Share <strong> %g </strong> <br />Green Vote Share <strong> %g </strong> <br />Other Vote Share <strong> %g </strong> <br />", Combo_WGS$NAME,Combo_WGS$Labour.Vote.Share.10,Combo_WGS$Conservative.Vote.Share.10,Combo_WGS$Lib.Dems.Vote.Share.10,Combo_WGS$UKIP.Vote.Share.10,Combo_WGS$SNP.Vote.Share.10,Combo_WGS$Green.Vote.Share.10,Combo_WGS$Other.Vote.Share.10
) %>% lapply(htmltools::HTML)

GE2015_Leaflet <- leaflet(GE2015_WGS) %>%
  addTiles(group = "OSM (default)") %>%
  fitBounds(-14.02,49.67,2.09,61.06) %>% 
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~Elec15pal(Winner.15), 
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labelelec2015,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "1px 1px"),
                textsize = "9px",
                direction = "auto", group = "Election 15")
  ) %>% addLegend("bottomright", pal = Elec15pal, values = ~Winner.15,
                  title = "Winner GE 2015",
                  labFormat = labelFormat(prefix = ""),
                  opacity = 1)

GE2010_Leaflet <- leaflet(Combo_WGS) %>%
  addTiles(group = "OSM (default)") %>%
  fitBounds(-14.02,49.67,2.09,61.06) %>% 
  addPolygons(fill = TRUE,
    stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~Elec10pal(Winner.10), 
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labelelec2010,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "1px 1px"),
                textsize = "9px",
                direction = "auto", group = "Election 10")
  ) %>% addLegend("bottomright", pal = Elec10pal, values = ~Winner.10,
                  title = "Winner GE 2010",
                  labFormat = labelFormat(prefix = ""),
                  opacity = 1)
              
Referendum_Leaflet <- leaflet(Combo_WGS) %>%
  addTiles(group = "OSM (default)") %>%
  fitBounds(-14.02,49.67,2.09,61.06) %>% 
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 0.9,
              color = ~altpal(Estimated.Leave.vote), 
              highlight = highlightOptions(
                weight = 3,
                color = "#666",
                dashArray = "5,5",
                fillOpacity = 0.9,
                bringToFront = TRUE),
              label = labelleave,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "1px 1px"),
                textsize = "9px",
                direction = "auto", group = "Referendum")
  ) %>% addLegend("bottomleft", pal = altpal, values = ~Estimated.Leave.vote,
                  title = "Leave Vote",
                  labFormat = labelFormat(prefix = ""),
                  opacity = 1)


saveWidget(GE2015_Leaflet,file = "Election_2015.html")
saveWidget(GE2010_Leaflet,file = "Election_2010.html")
saveWidget(Referendum_Leaflet,file = "EU_Referendum.html")

