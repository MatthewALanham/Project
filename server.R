library(shiny)
library(dplyr)
library(plyr)
library(ISLR)

#Read In Data
db <- read.csv("/Users/hiatts/Documents/R For Analytics/Project/Movie_Data.csv", sep=",", header=T)
db <- db%>%
  select(releaseMonth, releaseYear, Movie,
         Budget, Domestic, Worldwide)

#Generate Regression Coefficients
fit <- lm(Worldwide~ releaseMonth+Budget+Domestic, data=db)
#Define Coefficient List
regres <- coefficients((fit))


#Build Shiny App
function(input, output) {
  
  #Filter The Movies
  movies <- reactive({
    #Create Variables Based Off User Input
    minMonth <- input$Month[1]
    maxMonth <- input$Month[2]
    minYear <- input$Year[1]
    maxYear <- input$Year[2]
    minBudget <- input$Budget[1]
    maxBudget <- input$Budget[2]
    minDomestic <- input$Domestic_Grossing[1]
    maxDomestic <- input$Domestic_Grossing[2]
    minWorld <- input$Worldwide_Grossing[1]
    maxWorld <- input$Worldwide_Grossing[2]
    domesticBudget <- as.numeric(input$prodBudget)+as.numeric(input$dmarketingBudget)
    #Sum Total Budget For Regression
    totalBudget <- as.numeric(input$prodBudget)+as.numeric(input$dmarketingBudget)+
      as.numeric(input$wwMarketing)
    #Use Regression to generate value
    expectedWW <- as.numeric(input$predMonth)*regres[2] + regres[1]+
      as.numeric(input$dGrossings)*regres[4]+
      regres[3]*totalBudget
    
    #Apply Filters
    m <- db %>%
      filter(
        releaseMonth>=minMonth,
        releaseMonth<=maxMonth,
        releaseYear>=minYear,
        releaseYear<=maxYear,
        Budget>=minBudget,
        Budget<=maxBudget,
        Domestic>=minDomestic,
        Domestic<=maxDomestic,
        Worldwide>=minWorld,
        Worldwide<=maxWorld
      )
    
    #Create Graph of budget vs worldwide
    output$distplot <- renderPlot({
      plot(m$Budget, m$Worldwide, xlab="Budget ($M)",
           ylab="Worldwide Grossings($M)",
           main="Budget vs Worldwide Grossings",
           xlim=c(input$Budget[1],input$Budget[2]),
           ylim=c(input$Worldwide_Grossing[1],input$Worldwide_Grossing[2]),
           col="darkseagreen4")
    })
    
    #Generate graph of domestic vs worldwide
    output$budgPlot <- renderPlot({
      plot(m$Domestic, m$Worldwide, xlab="Domestic Grossings ($M)",
           ylab="Worldwide Grossings($M)", main="Domestic vs Worldwide Grossings",
           xlim=c(0,input$Domestic_Grossing[2]),
           ylim=c(0,input$Worldwide_Grossing[2]),
           col="darksalmon")
    })
    
    #Show expected earnings if button pressed
    observeEvent(input$predictWW,
                 { output$expWW <- renderText({
                   #Make negative earnings 0
                   if (expectedWW < 0) {
                     0
                   } else {
                     expectedWW
                   }
                   #(expectedWW)
                   }) 
                 #Generate Release Decision
                 output$decision <- renderText({
                   if (expectedWW > totalBudget) {
                     "Release Globally: Movie Will Make Additional Profit After Global Release"
                   } else if ((expectedWW- totalBudget) >
                              as.numeric(input$dGrossings)-domesticBudget) {
                     "Release Globally: Will Minimize Expected Monetary Loss"
                   } else {
                     "Do Not Release Globally: Global Release Will Increase Expected Monetary Loss"
                   }
                 })
                 })
  })

  

  #Text Output
  output$n_movies <- renderText({nrow(movies())})
}