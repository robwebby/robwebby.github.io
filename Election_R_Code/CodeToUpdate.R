library(sp)
library(rgdal)
library(raster)
library(plyr)
library(rgeos)
library(leaflet)
library(rmapshaper)
library(htmlwidgets)
library(DT)

setwd("~/Documents/GitHub/robwebby.github.io")
GE_2017 <- read.csv("GE2017_Results.csv")
GE_2017[,15:18] <- gsub('#N/A', 'No Result', GE_2017$Winner.17)

Constituencies <- readOGR("Constituencies_Simp.shp")
Constituencies_Ac <- readOGR("Constituencies_Simp.shp")
GE2017_WGS <- merge(Constituencies,GE_2017, by = "CODE")
GE2017_WGSAC <- merge(Constituencies_Ac,GE_2017, by = "CODE")
Party_Names <- c("Conservative","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")


GE_2017_VS <- GE_2017[,c(2,20:27)]
Con_Names <- as.data.frame(GE_2017$Constituency.Name)
Con_Data_VS <- GE_2017_VS[,-1]
rownames(Con_Data_VS) <- GE_2017_VS[,1]
GE_2017_VSC <- GE_2017[,c(2,28:35)]
Con_Data_VSC <- GE_2017_VSC[,-1]
rownames(Con_Data_VSC) <- GE_2017_VSC[,1]

setwd("~/Documents/GitHub/robwebby.github.io/2017_VSC_Plots")
for(i in 1:650){
  Constituencyinput <- i
  IndCon_Data_VSC <- Con_Data_VSC[Constituencyinput,]
  IndCon_Data_VSC <- as.matrix.data.frame(IndCon_Data_VSC)
  ylim_VSC <- c(min(t(IndCon_Data_VSC)),max(t(IndCon_Data_VSC)))
  Constituency <- as.character(Con_Names[Constituencyinput,])
  if (max(ylim_VSC)<=0) {
    
    print(paste(Constituency,"Not Called", sep = ""))
    
  }
  else{
    
    # Render a barplot
    VSC_Plot <- barplot(IndCon_Data_VSC, main= Constituency,
                        col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, names.arg = Party_Names, ylim = ylim_VSC, cex.sub = 1, font.sub = 4
                        ,las=2)
    setwd("~/Documents/GitHub/robwebby.github.io/2017_VSC_Plots")
    dev.print(png, paste(Constituency,"_VSC2017.png", sep = ""), width = 448, height = 356) 
    
    VS_Plot <- barplot(IndCon_Data_VS, main= Constituency,
                       col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, names.arg = Party_Names, ylim = ylim_VS, cex.sub = 1, font.sub = 4
                       ,las=2)
    setwd("~/Documents/GitHub/robwebby.github.io/2017_VS_Plots")
    dev.print(png, paste(Constituency,"_VS2017.png", sep = ""), width = 448, height = 356) 
    
  }}
Elec17pal <- colorFactor(c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold","darkorchid1"), GE2017_WGS$Winner.15)

Elec17palAC <- colorFactor(c("darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","gold","darkorchid1"), GE2017_WGSAC$Winner.15)

labelelec2017 <- sprintf(
  "<strong>%s</strong><br/>Winner: <strong>%s</strong><br/> Lab Vote Share <strong> %g<span>&#37;</span>   </strong> <br /> Con Vote Share <strong> %g<span>&#37;</span>   </strong> <br />Lib Dem Vote Share <strong> %g<span>&#37;</span>  </strong> <br />UKIP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />SNP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Green Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Other Vote Share <strong> %g<span>&#37;</span>  </strong> <br />", GE2017_WGS$Constituency.Name,GE2017_WGS$Winner.17,GE2017_WGS$Labour.Vote.Share.17,GE2017_WGS$Conservative.Vote.Share.17,GE2017_WGS$Lib.Dems.Vote.Share.17,GE2017_WGS$UKIP.Vote.Share.17,GE2017_WGS$SNP.Vote.Share.17,GE2017_WGS$Green.Vote.Share.17,GE2017_WGS$Other.Vote.Share.17
) %>% lapply(htmltools::HTML)

labelelec2017AC <- sprintf(
  "<strong>%s</strong><br/>Winner: <strong>%s</strong><br/> Lab Vote Share <strong> %g<span>&#37;</span>   </strong> <br /> Con Vote Share <strong> %g<span>&#37;</span>   </strong> <br />Lib Dem Vote Share <strong> %g<span>&#37;</span>  </strong> <br />UKIP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />SNP Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Green Vote Share <strong> %g<span>&#37;</span>  </strong> <br />Other Vote Share <strong> %g<span>&#37;</span>  </strong> <br />", GE2017_WGSAC$Constituency.Name,GE2017_WGSAC$Winner.17,GE2017_WGSAC$Labour.Vote.Share.17,GE2017_WGSAC$Conservative.Vote.Share.17,GE2017_WGSAC$Lib.Dems.Vote.Share.17,GE2017_WGSAC$UKIP.Vote.Share.17,GE2017_WGSAC$SNP.Vote.Share.17,GE2017_WGSAC$Green.Vote.Share.17,GE2017_WGSAC$Other.Vote.Share.17
) %>% lapply(htmltools::HTML)

GE2017_Leaflet <- leaflet(GE2017_WGS) %>%
  fitBounds(-17.02,49.67,2.09,58.06) %>% 
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~Elec17pal(Winner.17), 
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
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

GE2017_LeafletAC <- leaflet(GE2017_WGSAC) %>%
  addTiles(group = "OSM (default)") %>%
  fitBounds(-10.02,49.67,2.09,58.06) %>% 
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~Elec17palAC(Winner.17), 
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labelelec2017AC,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "1px 1px"),
                textsize = "9px",
                direction = "auto", group = "Election 17")
  ) %>% addLegend("bottomright", pal = Elec17palAC, values = ~Winner.17,
                  title = "Winner GE 2017",
                  labFormat = labelFormat(prefix = ""),
                  opacity = 1)

saveWidget(GE2017_Leaflet,file = "Election_2017_Cartogram.html")
saveWidget(GE2017_LeafletAC,file = "Election_2017.html")

GE_2017[,19:35] <- gsub('#DIV/0!', 'Awaiting Results', GE_2017$Winner.17)
rownames(GE_2017) <- GE_2017$Constituency.Name
GE_2017$Press.Association.Reference <- NULL
GE_2017[,14:34] <- NULL

datatable(GE_2017, rownames = FALSE,filter = 'top', options = list(pageLength = 25,autoWidth = TRUE))

