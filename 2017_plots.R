library(sp)
library(rgdal)
library(raster)
library(plyr)
library(rgeos)
library(leaflet)
library(rmapshaper)
library(htmlwidgets)

setwd("~/Documents/GitHub/robwebby.github.io")
GE_2017 <- read.csv("GE2017_Results.csv")
Constituencies <- readOGR("Constituencies_Simp.shp")
GE2017_WGS <- merge(Constituencies,GE_2017, by = "CODE")
Party_Names <- c("Conservative","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
Elec17pal <- colorFactor(c("white","darkblue","chartreuse","firebrick2","goldenrod3","dimgrey","darkgreen","yellow","darkorchid1"), GE2017_WGS$Winner.17)


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

eleclabel <- sprintf(
  "<strong>%s</strong><br/>
  Labour %g% (%g)", 
  GE2017_WGS$Constituency.Name,GE2017_WGS
) %>% lapply(htmltools::HTML)

Election <- leaflet(GE2017_WGS) %>%
  addTiles(group = "OSM (default)") %>%
  fitBounds(-14.02,49.67,2.09,61.06) %>% 
  addPolygons(stroke = FALSE,color = ~elecpal1(Winner.17),
              dashArray = "5,1", label = eleclabel,
              group = "Winners",weight = 0.2
              
  ) %>% 
  addPolygons(stroke = TRUE,color = ~elecpal1(Winner.17),
              label = eleclabel,
              group = "Winners"
              
  ) %>% 
  
  addLegend("bottomright", pal = Elec17pal, values = ~Winner.17,
            title = "Winner GE 2017",
            labFormat = labelFormat(prefix = ""),
            opacity = 1)
