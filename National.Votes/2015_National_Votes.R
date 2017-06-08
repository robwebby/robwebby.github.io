GE_2015 <- read.csv("GE2015_Results.csv")
library(tableHTML)

Party <- c("Conservatives","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
Votes <-  sum(GE_2015$Votes_15,na.rm=TRUE)
National.Votes <- c(sum(GE_2015$Conservative_15,na.rm=TRUE),sum(GE_2015$Green_15,na.rm=TRUE),sum(GE_2015$Labour_15,na.rm=TRUE),sum(GE_2015$Lib.Dems_15,na.rm=TRUE),sum(GE_2015$Other_15,na.rm=TRUE),sum(GE_2015$Plaid_15,na.rm=TRUE),sum(GE_2015$SNP_15,na.rm=TRUE),sum(GE_2015$UKIP_15,na.rm=TRUE))
National.VoteShare <- paste(round(National.Votes/Votes*100,1),"%",sep = "")

National.VS <- data.frame(National.Votes,National.VoteShare)
rownames(National.VS) <- Party
datatable(National.VS)

write_tableHTML(tableHTML(National.VS), file = 'NationalVS_2015.html')

xtable(National.VS)
