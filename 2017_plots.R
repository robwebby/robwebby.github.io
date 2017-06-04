setwd("~/Documents/GitHub/robwebby.github.io")
GE_2017 <- read.csv("GE2017_Results.csv")
Party_Names <- c("Con","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
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
    IndCon_Data_VSC[1,] <- c(0,0,0,0,0,0,0,0)
    VSC_Plot <- barplot(IndCon_Data_VSC, main= paste(Constituency,"NOT CALLED",sep = " ") ,
                        col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, names.arg = Party_Names, ylim = c(-10,10), cex.sub = 1, font.sub = 4
                        ,las=2)
    setwd("~/Documents/GitHub/robwebby.github.io/2017_VSC_Plots")
    dev.print(png, paste(Constituency,"_VSC2017.png", sep = ""), width = 448, height = 356)
    
    VS_Plot <- barplot(IndCon_Data_VSC, main= paste(Constituency,"NOT CALLED",sep = " "),
                       col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, names.arg = Party_Names, ylim = ylim_VS, cex.sub = 1, font.sub = 4
                       ,las=2)
    setwd("~/Documents/GitHub/robwebby.github.io/2017_VS_Plots")
    dev.print(png, paste(Constituency,"_VS2017.png", sep = ""), width = 448, height = 356) 
    
    
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
