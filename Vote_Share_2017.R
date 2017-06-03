GE_2017 <- read.csv("GE2017_Results.csv")
Party_Names <- c("Con","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
GE_2017_VS <- GE_2017[,c(2,28:35)]
Con_Names <- as.data.frame(GE_2017$Constituency.Name)
Con_Data <- GE_2017_VS[,-1]
rownames(Con_Data) <- GE_2017_VS[,1]

setwd("~/Documents/GitHub/robwebby.github.io/2015_VSC_Plots")
for(i in 1:650){
  Constituencyinput <- 1
  IndCon_Data <- Con_Data[Constituencyinput,]
  IndCon_Data <- as.matrix.data.frame(IndCon_Data)
  ylim <- c(min(t(IndCon_Data)),max(t(IndCon_Data)))
  Constituency <- as.character(Con_Names[Constituencyinput,])
  if (IndCon_Data[,1]<=0) {(print("NA"))}
  else{
  # Render a barplot
  VSPlot <- barplot(IndCon_Data, main= Constituency,
                    col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, names.arg = Party_Names, ylim = ylim, cex.sub = 1, font.sub = 4
                    ,las=2)
  dev.print(png, paste(Constituency,"_2017.png", sep = ""), width = 448, height = 356) 
  }
}

Constituencyinput <- 519

IndCon_Data <- Con_Data[Constituencyinput,]
IndCon_Data <- as.matrix.data.frame(IndCon_Data)
ylim <- c(min(t(IndCon_Data)),max(t(IndCon_Data)))
Constituency <- as.character(Con_Names[Constituencyinput,])
# Render a barplot
barplot(IndCon_Data, main= Constituency,
        col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, names.arg = Party_Names, ylim = ylim, cex.sub = 1, font.sub = 4
        ,las=2)
dev.print(png, paste(Constituency,"_2017.png", sep = ""), width = 448, height = 356) 

#W448 H356
#
