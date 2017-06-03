library(XML)
doc.html <- htmlTreeParse('index_old.html',
                         useInternal = TRUE)

Code <- "<option value=/2015_VSC_Plots/Aberavon_2015.png>Aberavon"

GE_2015 <- read.csv("GE2015_Results.csv")
Party_Names <- c("Conservative","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
GE_2015_VS <- GE_2015[,c(2,28:35)]
Con_Names <- as.data.frame(GE_2015$Constituency.Name)
Con_Data <- GE_2015_VS[,-1]
rownames(Con_Data) <- GE_2015_VS[,1]

df_total = data.frame()

for(i in 1:650){
  Constituencyinput <- i
  Constituency <- as.character(Con_Names[Constituencyinput,])
    code <- gsub("Aberavon", Constituency, Code)
    df <- data.frame(code)
    df_total <- rbind(df_total,df)
    print(code)
}

write.csv(df_total,"htmlcode15.csv")

?print
code2 <- replicate(2,Code)
