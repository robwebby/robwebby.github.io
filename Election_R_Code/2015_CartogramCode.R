setwd("/Users/robwebster/Documents/GitHub/robwebby.github.io")

Constituencies <- readOGR("Cartogram_GE.shp")

GE_2015 <- read.csv("GE2015_Results.csv")

GE2015_WGS <- merge(Constituencies,GE_2015, by = "CODE")

Elec15pal <- colorFactor(c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold","darkorchid1"), GE2015_WGS$Winner.15)

labelelec2015 <- sprintf(
  "<strong>%s</strong><br/>Winner: <strong>%s</strong><br/> Lab Vote Share <strong> %g<span>&#37;</span>  (%g<span>&#37;</span>) </strong> <br /> Con Vote Share <strong> %g<span>&#37;</span> (%g<span>&#37;</span>) </strong> <br />Lib Dem Vote Share <strong> %g<span>&#37;</span>  (%g<span>&#37;</span>)</strong> <br />UKIP Vote Share <strong> %g<span>&#37;</span> (%g<span>&#37;</span>) </strong> <br />SNP Vote Share <strong> %g<span>&#37;</span> (%g<span>&#37;</span>) </strong> <br />Green Vote Share <strong> %g<span>&#37;</span> (%g<span>&#37;</span>) </strong> <br />Other Vote Share <strong> %g<span>&#37;</span> (%g<span>&#37;</span>) </strong> <br />", GE2015_WGS$Constituency.Name,GE2015_WGS$Winner.15,GE2015_WGS$Labour.Vote.Share.15,GE2015_WGS$Labour.Vote.Share.Change.15,GE2015_WGS$Conservative.Vote.Share.15,GE2015_WGS$Conservative.Vote.Share.Change.15,GE2015_WGS$Lib.Dems.Vote.Share.15,GE2015_WGS$Lib.Dems.Vote.Share.Change.15,GE2015_WGS$UKIP.Vote.Share.15,GE2015_WGS$UKIP.Vote.Share.Change.15,GE2015_WGS$SNP.Vote.Share.15,GE2015_WGS$SNP.Vote.Share.Change.15,GE2015_WGS$Green.Vote.Share.15,GE2015_WGS$Green.Vote.Share.Change.15,GE2015_WGS$Other.Vote.Share.15,GE2015_WGS$Other.Vote.Share.Change.15
) %>% lapply(htmltools::HTML)

GE2015_Leaflet <- leaflet(GE2015_WGS) %>%
  fitBounds(-10.02,49.67,2.09,58.06) %>% 
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

saveWidget(GE2015_Leaflet,file = "Election_2015_Cartogram.html")
