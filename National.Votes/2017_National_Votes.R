library(tableHTML)

GE_2017 <- read.csv("GE2017_Results.csv")

Party <- c("Conservatives","Green","Labour","Lib Dem","Other","Plaid","SNP","UKIP")
Votes <-  sum(GE_2017$Votes_17,na.rm=TRUE)
National.Votes <- c(sum(GE_2017$Conservative_17,na.rm=TRUE),sum(GE_2017$Green_17,na.rm=TRUE),sum(GE_2017$Labour_17,na.rm=TRUE),sum(GE_2017$Lib.Dems_17,na.rm=TRUE),sum(GE_2017$Other_17,na.rm=TRUE),sum(GE_2017$Plaid_17,na.rm=TRUE),sum(GE_2017$SNP_17,na.rm=TRUE),sum(GE_2017$UKIP_17,na.rm=TRUE))
National.VoteShare <- paste(round(National.Votes/Votes*100,1),"%",sep = "")

National.VS <- data.frame(National.Votes,National.VoteShare)
rownames(National.VS) <- Party

write_tableHTML(tableHTML(National.VS), file = 'NationalVS_2017.html')
