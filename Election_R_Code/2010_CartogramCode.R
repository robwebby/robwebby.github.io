library(rgdal)
library(leaflet)
library(htmltools)
library(htmlwidgets)

setwd("/Users/robwebster/Documents/GitHub/robwebby.github.io")

Constituencies <- readOGR("Cartogram_GE.shp")

GE_2010 <- read.csv("GE2010_Results.csv")

GE2010_WGS <- merge(Constituencies,GE_2010, by = "CODE")

Elec10pal <- colorFactor(c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold","darkorchid1"), GE2015_WGS$Winner.15)

labelelec2010 <- sprintf(
  "<strong>%s</strong><br/>Winner: <strong>%s</strong><br/> Lab Vote Share <strong> %g<span>&#37;</span>   </strong> <br /> Con Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Lib Dem Vote Share <strong> %g<span>&#37;</span>  </strong> <br />UKIP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />SNP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Green Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Other Vote Share <strong> %g<span>&#37;</span>  </strong> <br />", GE2010_WGS$Constituency.Name,GE2010_WGS$Winner.10,GE2010_WGS$Labour.Vote.Share.10,GE2010_WGS$Conservative.Vote.Share.10,GE2010_WGS$Lib.Dems.Vote.Share.10,GE2010_WGS$UKIP.Vote.Share.10,GE2010_WGS$SNP.Vote.Share.10,GE2010_WGS$Green.Vote.Share.10,GE2010_WGS$Other.Vote.Share.10
) %>% lapply(htmltools::HTML)

GE2010_Leaflet <- leaflet(GE2010_WGS) %>%
  fitBounds(-10.02,49.67,2.09,58.06) %>% 
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
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

saveWidget(GE2010_Leaflet,file = "Election_2010_Cartogram.html")
