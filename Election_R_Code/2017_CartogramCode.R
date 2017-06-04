setwd("/Users/robwebster/Documents/GitHub/robwebby.github.io")

Constituencies <- readOGR("Cartogram_GE.shp")

GE_2017 <- read.csv("GE2017_Results.csv")
GE_2017$Winner.17 <- gsub('#N/A', 'No Result', GE_2017$Winner.17)

GE2017_WGS <- merge(Constituencies,GE_2017, by = "CODE")

Elec17pal <- colorFactor(c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold","darkorchid1"), GE2015_WGS$Winner.15)

labelelec2017 <- sprintf(
  "<strong>%s</strong><br/>Winner: <strong>%s</strong><br/> Lab Vote Share <strong> %g<span>&#37;</span>   </strong> <br /> Con Vote Share <strong> %g<span>&#37;</span>   </strong> <br />Lib Dem Vote Share <strong> %g<span>&#37;</span>  </strong> <br />UKIP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />SNP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Green Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Other Vote Share <strong> %g<span>&#37;</span>  </strong> <br />", GE2017_WGS$Constituency.Name,GE2017_WGS$Winner.17,GE2017_WGS$Labour.Vote.Share.17,GE2017_WGS$Conservative.Vote.Share.17,GE2017_WGS$Lib.Dems.Vote.Share.17,GE2017_WGS$UKIP.Vote.Share.17,GE2017_WGS$SNP.Vote.Share.17,GE2017_WGS$Green.Vote.Share.17,GE2017_WGS$Other.Vote.Share.17
) %>% lapply(htmltools::HTML)

GE2017_Leaflet <- leaflet(GE2017_WGS) %>%
  fitBounds(-17.02,49.67,2.09,58.06) %>% 
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~Elec17pal(Winner.17), 
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labelelec2017,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "1px 1px"),
                textsize = "9px",
                direction = "auto", group = "Election 17")
  ) %>% addLegend("bottomright", pal = Elec17pal, values = ~Winner.17,
                  title = "Winner GE 2017",
                  labFormat = labelFormat(prefix = ""),
                  opacity = 1)

saveWidget(GE2017_Leaflet,file = "Election_2017_Cartogram.html")
