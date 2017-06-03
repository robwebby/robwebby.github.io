# server.R


source("helpers.R")

# Define a server for the Shiny app
function(input, output) {
  
  # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({
    Constituency <- (input$region)
    Con_Data <- Con_Data[c(Constituency),]
    Con_Data <- as.matrix.data.frame(Con_Data)
    ylim <- c(min(t(Con_Data)),max(t(Con_Data)))
    # Render a barplot
    barplot(Con_Data, main="Vote share change by party",
            col=c("darkblue","green","red","gold","grey","darkgreen","yellow","purple"), beside=TRUE, sub = Constituency, names.arg = Party_Names, ylim = ylim
    )
  })
}

