GE_2015 <- read.csv("GE2015_Results.csv")
GE_2015_VS <- GE_2015[,c(2,28:35)]
Con_Data <- GE_2015_VS[,-1]
rownames(Con_Data) <- GE_2015_VS[,1]

VoteShare <- function(Data,Constituency){
  GE_2015_VS <- Data[,c(2,28:35)]
  Party_Names <- c("Conservative","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
  
  Constituency <- as.character(Constituency)
  
  colnames(GE_2015_VS)
  Constituency <- GE_2015_VS[ which(GE_2015_VS$Constituency.Name==Constituency),]
  samp2 <- Constituency[,-1]
  rownames(samp2) <- Constituency[,1]
  sampe2t <- t(samp2)
  Graph <-  barplot(sampe2t, main="Vote share change by party",
                    col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, xlim = c(1,8),ylim = c(-100,100)
  )
  return(Graph)
}


